import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../models/clan_member.dart';
import '../../../controllers/clan_providers.dart';

class BoardTab extends ConsumerStatefulWidget {
  final Clan clan;

  const BoardTab({super.key, required this.clan});

  @override
  ConsumerState<BoardTab> createState() => _BoardTabState();
}

class _BoardTabState extends ConsumerState<BoardTab> {
  final TextEditingController _postController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _postController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(clanBoardProvider(widget.clan.id));
    final currentMember = ref.watch(currentClanMemberProvider).value;

    return Column(
      children: [
        // Post composer
        if (currentMember != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post to Board',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _postController,
                  maxLines: 3,
                  maxLength: 280,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Share something with your clan...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(),
                    counterStyle: TextStyle(color: Colors.white60),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _postController.clear(),
                      child: const Text('Clear'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _postController.text.trim().isEmpty
                          ? null
                          : () => _postToBoard(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        // Posts list
        Expanded(
          child: posts.when(
            data: (postsList) {
              if (postsList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        color: Colors.white54,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Be the first to post something!',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: postsList.length,
                itemBuilder: (context, index) {
                  final post = postsList[index];
                  return _buildPostCard(context, post, currentMember);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.hpColor,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, post, ClanMember? currentMember) {
    final canPin = currentMember?.role.canPinPosts == true;
    final canDelete = currentMember?.role.canDeletePosts == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: post.pinned
            ? Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.accentColor.withValues(alpha: 0.2),
                child: Text(
                  post.authorName[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (post.pinned) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.push_pin,
                            color: AppTheme.accentColor,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatDate(post.createdAt),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Post actions
              if (canPin || canDelete)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white60),
                  onSelected: (value) => _handlePostAction(value, post),
                  itemBuilder: (context) => [
                    if (canPin)
                      PopupMenuItem(
                        value: post.pinned ? 'unpin' : 'pin',
                        child: Text(post.pinned ? 'Unpin Post' : 'Pin Post'),
                      ),
                    if (canDelete)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Post', style: TextStyle(color: AppTheme.hpColor)),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Post content
          Text(
            post.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Post footer
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Implement like functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Like functionality coming soon!'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                },
                icon: Icon(
                  Icons.thumb_up_outlined,
                  color: Colors.white60,
                  size: 20,
                ),
              ),
              Text(
                post.likes > 0 ? post.likes.toString() : '',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (post.pinned)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pinned',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _postToBoard() {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    ref.read(clanNotifierProvider.notifier).postToBoard(widget.clan.id, content);
    _postController.clear();
  }

  void _handlePostAction(String action, post) {
    switch (action) {
      case 'pin':
        ref.read(clanNotifierProvider.notifier).pinPost(post.id, true);
        break;
      case 'unpin':
        ref.read(clanNotifierProvider.notifier).pinPost(post.id, false);
        break;
      case 'delete':
        _showDeleteDialog(post);
        break;
    }
  }

  void _showDeleteDialog(post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Delete Post',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(clanNotifierProvider.notifier).deletePost(post.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
    );
  }
}
