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

    const { application_id } = await req.json()

    // Get the current user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the application
    const { data: application, error: appError } = await supabaseClient
      .from('clan_applications')
      .select(`
        *,
        clans!inner(*)
      `)
      .eq('id', application_id)
      .single()

    if (appError || !application) {
      return new Response(
        JSON.stringify({ error: 'Application not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user is leader or advisor of the clan
    const { data: member, error: memberError } = await supabaseClient
      .from('clan_members')
      .select('role')
      .eq('clan_id', application.clan_id)
      .eq('user_id', user.id)
      .single()

    if (memberError || !member || (member.role !== 'LEADER' && member.role !== 'ADVISOR')) {
      return new Response(
        JSON.stringify({ error: 'Insufficient permissions' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if applicant is already in a clan
    const { data: existingMember } = await supabaseClient
      .from('clan_members')
      .select('id')
      .eq('user_id', application.user_id)
      .single()

    if (existingMember) {
      return new Response(
        JSON.stringify({ error: 'User is already in a clan' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Start transaction
    const { error: updateError } = await supabaseClient
      .from('clan_applications')
      .update({ status: 'APPROVED' })
      .eq('id', application_id)

    if (updateError) {
      return new Response(
        JSON.stringify({ error: 'Failed to approve application' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Add user to clan
    const { error: insertError } = await supabaseClient
      .from('clan_members')
      .insert({
        clan_id: application.clan_id,
        user_id: application.user_id,
        role: 'MEMBER',
        display_name: application.user_id, // This should be fetched from user profile
      })

    if (insertError) {
      // Rollback application status
      await supabaseClient
        .from('clan_applications')
        .update({ status: 'PENDING' })
        .eq('id', application_id)

      return new Response(
        JSON.stringify({ error: 'Failed to add member to clan' }),
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
