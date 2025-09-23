import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    const { clan_id } = await req.json()

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the clan
    const { data: clan, error: clanError } = await supabaseClient
      .from('clans')
      .select(`
        *,
        villages!inner(*)
      `)
      .eq('id', clan_id)
      .single()

    if (clanError || !clan) {
      return new Response(
        JSON.stringify({ error: 'Clan not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user is the clan leader or the village kage
    const { data: member, error: memberError } = await supabaseClient
      .from('clan_members')
      .select('role')
      .eq('clan_id', clan_id)
      .eq('user_id', user.id)
      .single()

    const isLeader = !memberError && member && member.role === 'LEADER'
    const isKage = clan.villages.kage_user_id === user.id

    if (!isLeader && !isKage) {
      return new Response(
        JSON.stringify({ error: 'Only clan leaders or village kage can disband clans' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Delete all clan members (cascade will handle this, but we do it explicitly for clarity)
    const { error: deleteMembersError } = await supabaseClient
      .from('clan_members')
      .delete()
      .eq('clan_id', clan_id)

    if (deleteMembersError) {
      return new Response(
        JSON.stringify({ error: 'Failed to remove clan members' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Reject all pending applications
    const { error: rejectAppsError } = await supabaseClient
      .from('clan_applications')
      .update({ status: 'REJECTED' })
      .eq('clan_id', clan_id)
      .eq('status', 'PENDING')

    if (rejectAppsError) {
      console.error('Failed to reject applications:', rejectAppsError)
      // Don't fail the request since the main operation succeeded
    }

    // Delete all board posts
    const { error: deletePostsError } = await supabaseClient
      .from('clan_board_posts')
      .delete()
      .eq('clan_id', clan_id)

    if (deletePostsError) {
      console.error('Failed to delete board posts:', deletePostsError)
      // Don't fail the request since the main operation succeeded
    }

    // Delete the clan
    const { error: deleteClanError } = await supabaseClient
      .from('clans')
      .delete()
      .eq('id', clan_id)

    if (deleteClanError) {
      return new Response(
        JSON.stringify({ error: 'Failed to disband clan' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
