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

    const { village_id, name, description, emblem_url } = await req.json()

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user is already in a clan
    const { data: existingMember } = await supabaseClient
      .from('clan_members')
      .select('id')
      .eq('user_id', user.id)
      .single()

    if (existingMember) {
      return new Response(
        JSON.stringify({ error: 'You are already in a clan' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user has a pending application
    const { data: pendingApp } = await supabaseClient
      .from('clan_applications')
      .select('id')
      .eq('user_id', user.id)
      .eq('status', 'PENDING')
      .single()

    if (pendingApp) {
      return new Response(
        JSON.stringify({ error: 'You have a pending application to another clan' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get village info and check if user is kage
    const { data: village, error: villageError } = await supabaseClient
      .from('villages')
      .select('*')
      .eq('id', village_id)
      .single()

    if (villageError || !village) {
      return new Response(
        JSON.stringify({ error: 'Village not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (village.kage_user_id !== user.id) {
      return new Response(
        JSON.stringify({ error: 'Only village kage can create clans' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check clan count limit
    const { data: existingClans, error: clansError } = await supabaseClient
      .from('clans')
      .select('id')
      .eq('village_id', village_id)

    if (clansError) {
      return new Response(
        JSON.stringify({ error: 'Failed to check existing clans' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const maxClans = village.max_clans || 3
    if (existingClans && existingClans.length >= maxClans) {
      return new Response(
        JSON.stringify({ error: `Maximum number of clans (${maxClans}) reached for this village` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if clan name is unique in the village
    const { data: nameExists } = await supabaseClient
      .from('clans')
      .select('id')
      .eq('village_id', village_id)
      .eq('name', name)
      .single()

    if (nameExists) {
      return new Response(
        JSON.stringify({ error: 'A clan with this name already exists in the village' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create the clan
    const { data: newClan, error: createError } = await supabaseClient
      .from('clans')
      .insert({
        name,
        village_id,
        leader_id: user.id,
        description,
        emblem_url,
      })
      .select()
      .single()

    if (createError) {
      return new Response(
        JSON.stringify({ error: 'Failed to create clan' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Add the creator as the leader
    const { error: addMemberError } = await supabaseClient
      .from('clan_members')
      .insert({
        clan_id: newClan.id,
        user_id: user.id,
        role: 'LEADER',
        display_name: user.user_metadata?.display_name || user.email || 'Unknown',
      })

    if (addMemberError) {
      // Rollback: delete the clan
      await supabaseClient
        .from('clans')
        .delete()
        .eq('id', newClan.id)

      return new Response(
        JSON.stringify({ error: 'Failed to add creator as clan member' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify(newClan),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
