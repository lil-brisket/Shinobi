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

    const { clan_id, new_leader_id } = await req.json()

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if current user is leader of the clan
    const { data: currentMember, error: currentMemberError } = await supabaseClient
      .from('clan_members')
      .select('role')
      .eq('clan_id', clan_id)
      .eq('user_id', user.id)
      .single()

    if (currentMemberError || !currentMember || currentMember.role !== 'LEADER') {
      return new Response(
        JSON.stringify({ error: 'Only clan leaders can transfer leadership' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the new leader
    const { data: newLeader, error: newLeaderError } = await supabaseClient
      .from('clan_members')
      .select('*')
      .eq('clan_id', clan_id)
      .eq('user_id', new_leader_id)
      .single()

    if (newLeaderError || !newLeader) {
      return new Response(
        JSON.stringify({ error: 'New leader not found in clan' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if new leader is already the leader
    if (newLeader.role === 'LEADER') {
      return new Response(
        JSON.stringify({ error: 'User is already the leader' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Start transaction: demote current leader and promote new leader
    const { error: demoteError } = await supabaseClient
      .from('clan_members')
      .update({ role: 'MEMBER' })
      .eq('clan_id', clan_id)
      .eq('user_id', user.id)

    if (demoteError) {
      return new Response(
        JSON.stringify({ error: 'Failed to demote current leader' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { error: promoteError } = await supabaseClient
      .from('clan_members')
      .update({ role: 'LEADER' })
      .eq('id', newLeader.id)

    if (promoteError) {
      // Rollback: promote current leader back
      await supabaseClient
        .from('clan_members')
        .update({ role: 'LEADER' })
        .eq('clan_id', clan_id)
        .eq('user_id', user.id)

      return new Response(
        JSON.stringify({ error: 'Failed to promote new leader' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Update clan leader_id
    const { error: updateClanError } = await supabaseClient
      .from('clans')
      .update({ leader_id: new_leader_id })
      .eq('id', clan_id)

    if (updateClanError) {
      // Rollback: restore original leader
      await supabaseClient
        .from('clan_members')
        .update({ role: 'LEADER' })
        .eq('clan_id', clan_id)
        .eq('user_id', user.id)

      await supabaseClient
        .from('clan_members')
        .update({ role: newLeader.role })
        .eq('id', newLeader.id)

      await supabaseClient
        .from('clans')
        .update({ leader_id: user.id })
        .eq('id', clan_id)

      return new Response(
        JSON.stringify({ error: 'Failed to update clan leader' }),
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
