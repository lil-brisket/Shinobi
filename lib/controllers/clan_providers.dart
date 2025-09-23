import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clan.dart';
import '../models/clan_member.dart';
import '../models/clan_application.dart';
import '../models/clan_board_post.dart';
import '../services/clan_service.dart';
import '../utils/snackbar_utils.dart';

// Service provider
final clanServiceProvider = Provider<ClanService>((ref) => ClanService());

// Current user's clan
final currentClanProvider = FutureProvider<Clan?>((ref) async {
  final service = ref.read(clanServiceProvider);
  return service.getMyClan();
});

// Current user's clan member info
final currentClanMemberProvider = FutureProvider<ClanMember?>((ref) async {
  final service = ref.read(clanServiceProvider);
  return service.getMyClanMember();
});

// Current user's pending application
final myApplicationProvider = FutureProvider<ClanApplication?>((ref) async {
  final service = ref.read(clanServiceProvider);
  return service.getMyApplication();
});

// Clan members for a specific clan
final clanMembersProvider = FutureProvider.family<List<ClanMember>, String>((ref, clanId) async {
  final service = ref.read(clanServiceProvider);
  return service.getMembers(clanId);
});

// Clan board posts
final clanBoardProvider = FutureProvider.family<List<ClanBoardPost>, String>((ref, clanId) async {
  final service = ref.read(clanServiceProvider);
  return service.getBoard(clanId);
});

// Clan requests (for leaders/advisors)
final clanRequestsProvider = FutureProvider.family<List<ClanApplicationWithDetails>, String>((ref, clanId) async {
  final service = ref.read(clanServiceProvider);
  return service.getRequests(clanId);
});

// Browse clans by village
final browseClansProvider = FutureProvider.family<List<ClanWithDetails>, ({String villageId, String query})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  return service.listClans(villageId: params.villageId, query: params.query);
});

// Clan rankings
final clanRankingsProvider = FutureProvider.family<List<ClanWithDetails>, ({String? villageId, String sortBy})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  return service.getClanRankings(villageId: params.villageId, sortBy: params.sortBy);
});

// Mutation providers
final applyToClanProvider = FutureProvider.family<void, ({String clanId, String? message})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  await service.applyToClan(params.clanId, message: params.message);
  
  // Invalidate related providers
  ref.invalidate(myApplicationProvider);
  ref.invalidate(currentClanProvider);
});

final withdrawApplicationProvider = FutureProvider<void>((ref) async {
  final service = ref.read(clanServiceProvider);
  await service.withdrawMyApplication();
  
  // Invalidate related providers
  ref.invalidate(myApplicationProvider);
});

final approveApplicationProvider = FutureProvider.family<void, String>((ref, applicationId) async {
  final service = ref.read(clanServiceProvider);
  await service.approveApplication(applicationId);
  
  // Invalidate related providers
  ref.invalidate(clanRequestsProvider);
  ref.invalidate(clanMembersProvider);
  ref.invalidate(currentClanProvider);
});

final rejectApplicationProvider = FutureProvider.family<void, String>((ref, applicationId) async {
  final service = ref.read(clanServiceProvider);
  await service.rejectApplication(applicationId);
  
  // Invalidate related providers
  ref.invalidate(clanRequestsProvider);
});

final promoteMemberProvider = FutureProvider.family<void, String>((ref, userId) async {
  final service = ref.read(clanServiceProvider);
  await service.promoteMember(userId);
  
  // Invalidate related providers
  ref.invalidate(clanMembersProvider);
  ref.invalidate(currentClanMemberProvider);
});

final demoteMemberProvider = FutureProvider.family<void, String>((ref, userId) async {
  final service = ref.read(clanServiceProvider);
  await service.demoteMember(userId);
  
  // Invalidate related providers
  ref.invalidate(clanMembersProvider);
  ref.invalidate(currentClanMemberProvider);
});

final transferLeadershipProvider = FutureProvider.family<void, ({String clanId, String toUserId})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  await service.transferLeadership(params.clanId, params.toUserId);
  
  // Invalidate related providers
  ref.invalidate(clanMembersProvider);
  ref.invalidate(currentClanProvider);
  ref.invalidate(currentClanMemberProvider);
});

final leaveClanProvider = FutureProvider<void>((ref) async {
  final service = ref.read(clanServiceProvider);
  await service.leaveClan();
  
  // Invalidate related providers
  ref.invalidate(currentClanProvider);
  ref.invalidate(currentClanMemberProvider);
  ref.invalidate(myApplicationProvider);
});

final disbandClanProvider = FutureProvider.family<void, String>((ref, clanId) async {
  final service = ref.read(clanServiceProvider);
  await service.disbandClan(clanId);
  
  // Invalidate related providers
  ref.invalidate(currentClanProvider);
  ref.invalidate(currentClanMemberProvider);
  ref.invalidate(myApplicationProvider);
});

final createClanProvider = FutureProvider.family<Clan, ({String villageId, String name, String? description, String? emblemUrl})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  final clan = await service.createClan(
    villageId: params.villageId,
    name: params.name,
    description: params.description,
    emblemUrl: params.emblemUrl,
  );
  
  // Invalidate related providers
  ref.invalidate(currentClanProvider);
  ref.invalidate(currentClanMemberProvider);
  ref.invalidate(browseClansProvider);
  
  return clan;
});

final updateClanProvider = FutureProvider.family<void, ({String clanId, String? name, String? description, String? emblemUrl})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  await service.updateClan(
    params.clanId,
    name: params.name,
    description: params.description,
    emblemUrl: params.emblemUrl,
  );
  
  // Invalidate related providers
  ref.invalidate(currentClanProvider);
  ref.invalidate(browseClansProvider);
});

final postToBoardProvider = FutureProvider.family<void, ({String clanId, String content})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  await service.postToBoard(params.clanId, params.content);
  
  // Invalidate related providers
  ref.invalidate(clanBoardProvider);
});

final pinPostProvider = FutureProvider.family<void, ({String postId, bool pinned})>((ref, params) async {
  final service = ref.read(clanServiceProvider);
  await service.pinPost(params.postId, params.pinned);
  
  // Invalidate related providers
  ref.invalidate(clanBoardProvider);
});

final deletePostProvider = FutureProvider.family<void, String>((ref, postId) async {
  final service = ref.read(clanServiceProvider);
  await service.deletePost(postId);
  
  // Invalidate related providers
  ref.invalidate(clanBoardProvider);
});

// Notifier for handling mutations with error handling and UI feedback
class ClanNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  ClanNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> applyToClan(String clanId, {String? message}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(applyToClanProvider((clanId: clanId, message: message)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Application submitted successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to apply to clan: $e');
    }
  }

  Future<void> withdrawApplication() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(withdrawApplicationProvider.future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Application withdrawn successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to withdraw application: $e');
    }
  }

  Future<void> approveApplication(String applicationId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(approveApplicationProvider(applicationId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Application approved!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to approve application: $e');
    }
  }

  Future<void> rejectApplication(String applicationId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(rejectApplicationProvider(applicationId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Application rejected!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to reject application: $e');
    }
  }

  Future<void> promoteMember(String userId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(promoteMemberProvider(userId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Member promoted successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to promote member: $e');
    }
  }

  Future<void> demoteMember(String userId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(demoteMemberProvider(userId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Member demoted successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to demote member: $e');
    }
  }

  Future<void> transferLeadership(String clanId, String toUserId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(transferLeadershipProvider((clanId: clanId, toUserId: toUserId)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Leadership transferred successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to transfer leadership: $e');
    }
  }

  Future<void> leaveClan() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(leaveClanProvider.future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Left clan successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to leave clan: $e');
    }
  }

  Future<void> disbandClan(String clanId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(disbandClanProvider(clanId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Clan disbanded successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to disband clan: $e');
    }
  }

  Future<void> createClan({
    required String villageId,
    required String name,
    String? description,
    String? emblemUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(createClanProvider((villageId: villageId, name: name, description: description, emblemUrl: emblemUrl)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Clan created successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to create clan: $e');
    }
  }

  Future<void> updateClan(String clanId, {
    String? name,
    String? description,
    String? emblemUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(updateClanProvider((clanId: clanId, name: name, description: description, emblemUrl: emblemUrl)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Clan updated successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to update clan: $e');
    }
  }

  Future<void> postToBoard(String clanId, String content) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(postToBoardProvider((clanId: clanId, content: content)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Posted to board successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to post to board: $e');
    }
  }

  Future<void> pinPost(String postId, bool pinned) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(pinPostProvider((postId: postId, pinned: pinned)).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar(pinned ? 'Post pinned!' : 'Post unpinned!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to pin post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(deletePostProvider(postId).future);
      state = const AsyncValue.data(null);
      showSuccessSnackbar('Post deleted successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showErrorSnackbar('Failed to delete post: $e');
    }
  }
}

final clanNotifierProvider = StateNotifierProvider<ClanNotifier, AsyncValue<void>>((ref) {
  return ClanNotifier(ref);
});
