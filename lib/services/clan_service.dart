import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/clan.dart';
import '../models/clan_member.dart';
import '../models/clan_application.dart';
import '../models/clan_board_post.dart';

class ClanService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Clan queries
  Future<List<ClanWithDetails>> listClans({
    required String villageId,
    String query = '',
  }) async {
    try {
      // First, get all clans for the village
      var queryBuilder = _supabase
          .from('clans')
          .select('*')
          .eq('village_id', villageId);

      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('name', '%$query%');
      }

      final clans = await queryBuilder.order('score', ascending: false).order('name');

      // For each clan, get member count and leader info
      List<ClanWithDetails> clanDetails = [];
      for (final clanData in clans) {
        // Get member count
        final memberCount = await _supabase
            .from('clan_members')
            .select('id')
            .eq('clan_id', clanData['id']);

        // Get advisor count
        final advisorCount = await _supabase
            .from('clan_members')
            .select('id')
            .eq('clan_id', clanData['id'])
            .eq('role', 'ADVISOR');

        // Get leader name
        String leaderName = 'Unknown';
        if (clanData['leader_id'] != null) {
          try {
            final leader = await _supabase.auth.admin.getUserById(clanData['leader_id']);
            leaderName = leader.user?.userMetadata?['display_name'] ?? 'Unknown';
          } catch (e) {
            // If we can't get leader info, use default
            leaderName = 'Unknown';
          }
        }

        // Create Clan object
        final clan = Clan(
          id: clanData['id'],
          name: clanData['name'],
          description: clanData['description'],
          villageId: clanData['village_id'],
          leaderId: clanData['leader_id'] ?? '',
          emblemUrl: clanData['emblem_url'],
          score: clanData['score'] ?? 0,
          wins: clanData['wins'] ?? 0,
          losses: clanData['losses'] ?? 0,
          createdAt: DateTime.parse(clanData['created_at']),
          updatedAt: clanData['updated_at'] != null ? DateTime.parse(clanData['updated_at']) : null,
        );

        clanDetails.add(ClanWithDetails(
          clan: clan,
          leaderName: leaderName,
          memberCount: memberCount.length,
          advisorCount: advisorCount.length,
        ));
      }

      return clanDetails;
    } catch (e) {
      throw Exception('Failed to fetch clans: $e');
    }
  }

  Future<Clan?> getMyClan() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('clan_members')
          .select('''
            clan_id,
            clans!inner(*)
          ''')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;

      return Clan.fromJson(response['clans']);
    } catch (e) {
      throw Exception('Failed to fetch my clan: $e');
    }
  }

  Future<Clan?> getClanById(String clanId) async {
    try {
      final response = await _supabase
          .from('clans')
          .select('*')
          .eq('id', clanId)
          .maybeSingle();

      if (response == null) return null;
      return Clan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch clan: $e');
    }
  }

  // Clan member queries
  Future<List<ClanMember>> getMembers(String clanId) async {
    try {
      final response = await _supabase
          .from('clan_members')
          .select('*')
          .eq('clan_id', clanId)
          .order('role', ascending: true)
          .order('joined_at', ascending: true);

      return (response as List)
          .map((json) => ClanMember.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch clan members: $e');
    }
  }

  Future<ClanMember?> getMyClanMember() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('clan_members')
          .select('*')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return ClanMember.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch my clan member: $e');
    }
  }

  // Board queries
  Future<List<ClanBoardPost>> getBoard(String clanId, {String? cursor}) async {
    try {
      final response = await _supabase
          .from('clan_board_posts')
          .select('*')
          .eq('clan_id', clanId)
          .order('pinned', ascending: false)
          .order('created_at', ascending: false)
          .limit(20);

      return (response as List)
          .map((json) => ClanBoardPost.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch board posts: $e');
    }
  }

  // Application queries
  Future<List<ClanApplicationWithDetails>> getRequests(String clanId) async {
    try {
      final response = await _supabase
          .from('clan_applications')
          .select('''
            *,
            auth.users!inner(display_name)
          ''')
          .eq('clan_id', clanId)
          .eq('status', 'PENDING')
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        return ClanApplicationWithDetails(
          application: ClanApplication.fromJson(json),
          userName: json['auth.users']['display_name'],
          clanName: '', // Will be filled by caller if needed
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch clan requests: $e');
    }
  }

  Future<ClanApplication?> getMyApplication() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('clan_applications')
          .select('*')
          .eq('user_id', user.id)
          .eq('status', 'PENDING')
          .maybeSingle();

      if (response == null) return null;
      return ClanApplication.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch my application: $e');
    }
  }

  // Mutations
  Future<void> applyToClan(String clanId, {String? message}) async {
    try {
      await _supabase.from('clan_applications').insert({
        'clan_id': clanId,
        'user_id': _supabase.auth.currentUser!.id,
        'message': message,
        'status': 'PENDING',
      });
    } catch (e) {
      throw Exception('Failed to apply to clan: $e');
    }
  }

  Future<void> withdrawMyApplication() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await _supabase
          .from('clan_applications')
          .update({'status': 'WITHDRAWN'})
          .eq('user_id', user.id)
          .eq('status', 'PENDING');
    } catch (e) {
      throw Exception('Failed to withdraw application: $e');
    }
  }

  Future<void> approveApplication(String applicationId) async {
    try {
      await _supabase.rpc('approve_clan_application', params: {
        'application_id': applicationId,
      });
    } catch (e) {
      throw Exception('Failed to approve application: $e');
    }
  }

  Future<void> rejectApplication(String applicationId) async {
    try {
      await _supabase
          .from('clan_applications')
          .update({'status': 'REJECTED'})
          .eq('id', applicationId);
    } catch (e) {
      throw Exception('Failed to reject application: $e');
    }
  }

  Future<void> promoteMember(String userId) async {
    try {
      await _supabase.rpc('promote_clan_member', params: {
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to promote member: $e');
    }
  }

  Future<void> demoteMember(String userId) async {
    try {
      await _supabase.rpc('demote_clan_member', params: {
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to demote member: $e');
    }
  }

  Future<void> transferLeadership(String clanId, String toUserId) async {
    try {
      await _supabase.rpc('transfer_clan_leadership', params: {
        'clan_id': clanId,
        'new_leader_id': toUserId,
      });
    } catch (e) {
      throw Exception('Failed to transfer leadership: $e');
    }
  }

  Future<void> leaveClan() async {
    try {
      await _supabase.rpc('leave_clan');
    } catch (e) {
      throw Exception('Failed to leave clan: $e');
    }
  }

  Future<void> disbandClan(String clanId) async {
    try {
      await _supabase.rpc('disband_clan', params: {
        'clan_id': clanId,
      });
    } catch (e) {
      throw Exception('Failed to disband clan: $e');
    }
  }

  Future<Clan> createClan({
    required String villageId,
    required String name,
    String? description,
    String? emblemUrl,
  }) async {
    try {
      final response = await _supabase.rpc('create_clan_checked', params: {
        'village_id': villageId,
        'name': name,
        'description': description,
        'emblem_url': emblemUrl,
      });

      return Clan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create clan: $e');
    }
  }

  Future<void> updateClan(String clanId, {
    String? name,
    String? description,
    String? emblemUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (emblemUrl != null) updates['emblem_url'] = emblemUrl;

      await _supabase
          .from('clans')
          .update(updates)
          .eq('id', clanId);
    } catch (e) {
      throw Exception('Failed to update clan: $e');
    }
  }

  Future<void> postToBoard(String clanId, String content) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await _supabase.from('clan_board_posts').insert({
        'clan_id': clanId,
        'author_id': user.id,
        'author_name': user.userMetadata?['display_name'] ?? 'Unknown',
        'content': content,
      });
    } catch (e) {
      throw Exception('Failed to post to board: $e');
    }
  }

  Future<void> pinPost(String postId, bool pinned) async {
    try {
      await _supabase
          .from('clan_board_posts')
          .update({'pinned': pinned})
          .eq('id', postId);
    } catch (e) {
      throw Exception('Failed to pin post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _supabase
          .from('clan_board_posts')
          .delete()
          .eq('id', postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Rankings
  Future<List<ClanWithDetails>> getClanRankings({
    String? villageId,
    String sortBy = 'score',
  }) async {
    try {
      // Get clans with optional village filter
      var queryBuilder = _supabase.from('clans').select('*');
      
      if (villageId != null) {
        queryBuilder = queryBuilder.eq('village_id', villageId);
      }

      // Apply sorting and limit
      PostgrestTransformBuilder<List<Map<String, dynamic>>> sortedQuery;
      if (sortBy == 'score') {
        sortedQuery = queryBuilder.order('score', ascending: false);
      } else if (sortBy == 'name') {
        sortedQuery = queryBuilder.order('name', ascending: true);
      } else if (sortBy == 'created_at') {
        sortedQuery = queryBuilder.order('created_at', ascending: false);
      } else {
        sortedQuery = queryBuilder.order('score', ascending: false);
      }

      final clans = await sortedQuery.limit(50);

      // For each clan, get member count and leader info
      List<ClanWithDetails> clanDetails = [];
      for (final clanData in clans) {
        // Get member count
        final memberCount = await _supabase
            .from('clan_members')
            .select('id')
            .eq('clan_id', clanData['id']);

        // Get advisor count
        final advisorCount = await _supabase
            .from('clan_members')
            .select('id')
            .eq('clan_id', clanData['id'])
            .eq('role', 'ADVISOR');

        // Get leader name
        String leaderName = 'Unknown';
        if (clanData['leader_id'] != null) {
          try {
            final leader = await _supabase.auth.admin.getUserById(clanData['leader_id']);
            leaderName = leader.user?.userMetadata?['display_name'] ?? 'Unknown';
          } catch (e) {
            // If we can't get leader info, use default
            leaderName = 'Unknown';
          }
        }

        // Create Clan object
        final clan = Clan(
          id: clanData['id'],
          name: clanData['name'],
          description: clanData['description'],
          villageId: clanData['village_id'],
          leaderId: clanData['leader_id'] ?? '',
          emblemUrl: clanData['emblem_url'],
          score: clanData['score'] ?? 0,
          wins: clanData['wins'] ?? 0,
          losses: clanData['losses'] ?? 0,
          createdAt: DateTime.parse(clanData['created_at']),
          updatedAt: clanData['updated_at'] != null ? DateTime.parse(clanData['updated_at']) : null,
        );

        clanDetails.add(ClanWithDetails(
          clan: clan,
          leaderName: leaderName,
          memberCount: memberCount.length,
          advisorCount: advisorCount.length,
        ));
      }

      return clanDetails;
    } catch (e) {
      throw Exception('Failed to fetch clan rankings: $e');
    }
  }
}
