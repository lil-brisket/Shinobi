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

    const { user_id } = await req.json()

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the member to demote
    const { data: member, error: memberError } = await supabaseClient
      .from('clan_members')
      .select(`
        *,
        clans!inner(*)
      `)
      .eq('user_id', user_id)
      .single()

    if (memberError || !member) {
      return new Response(
        JSON.stringify({ error: 'Member not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if current user is leader of the clan
    const { data: currentMember, error: currentMemberError } = await supabaseClient
      .from('clan_members')
      .select('role')
      .eq('clan_id', member.clan_id)
      .eq('user_id', user.id)
      .single()

    if (currentMemberError || !currentMember || currentMember.role !== 'LEADER') {
      return new Response(
        JSON.stringify({ error: 'Only clan leaders can demote members' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if member is an advisor (can only demote advisors)
    if (member.role !== 'ADVISOR') {
      return new Response(
        JSON.stringify({ error: 'Can only demote advisors to members' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Demote advisor to member
    const { error: updateError } = await supabaseClient
      .from('clan_members')
      .update({ role: 'MEMBER' })
      .eq('id', member.id)

    if (updateError) {
      return new Response(
        JSON.stringify({ error: 'Failed to demote member' }),
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
