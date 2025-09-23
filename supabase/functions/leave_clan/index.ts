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

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the user's clan membership
    const { data: member, error: memberError } = await supabaseClient
      .from('clan_members')
      .select(`
        *,
        clans!inner(*)
      `)
      .eq('user_id', user.id)
      .single()

    if (memberError || !member) {
      return new Response(
        JSON.stringify({ error: 'You are not in a clan' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user is the leader
    if (member.role === 'LEADER') {
      // Check if there are other members
      const { data: otherMembers, error: membersError } = await supabaseClient
        .from('clan_members')
        .select('id')
        .eq('clan_id', member.clan_id)
        .neq('user_id', user.id)

      if (membersError) {
        return new Response(
          JSON.stringify({ error: 'Failed to check clan members' }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }

      if (otherMembers && otherMembers.length > 0) {
        return new Response(
          JSON.stringify({ error: 'Cannot leave clan as leader with other members. Transfer leadership first.' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }
    }

    // Remove user from clan
    const { error: deleteError } = await supabaseClient
      .from('clan_members')
      .delete()
      .eq('id', member.id)

    if (deleteError) {
      return new Response(
        JSON.stringify({ error: 'Failed to leave clan' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // If the user was the leader and there are no other members, delete the clan
    if (member.role === 'LEADER') {
      const { error: deleteClanError } = await supabaseClient
        .from('clans')
        .delete()
        .eq('id', member.clan_id)

      if (deleteClanError) {
        console.error('Failed to delete empty clan:', deleteClanError)
        // Don't fail the request since the user has already left
      }
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
