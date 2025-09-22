import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/section_header.dart';
import '../../widgets/info_card.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/chat.dart';
import '../../models/stats.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final news = ref.watch(newsProvider);
    final chatMessages = ref.watch(chatProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${player.name}!',
                        style: AppTheme.headingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hidden Leaf Village • Level ${player.stats.level}',
                        style: AppTheme.descriptionStyle,
                      ),
                    ],
                  ),
                ),

                // Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: '${player.ryo}',
                          subtitle: 'Ryo',
                          leadingWidget: const Icon(
                            Icons.monetization_on,
                            color: AppTheme.ryoColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          title: '${_getCurrentHP(player.stats)}/${_getMaxHP(player.stats)}',
                          subtitle: 'HP',
                          leadingWidget: const Icon(
                            Icons.favorite,
                            color: AppTheme.hpColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Latest News Section
                SectionHeader(
                  title: 'Latest News',
                  trailing: TextButton(
                    onPressed: () {
                      // TODO: Navigate to full news screen
                    },
                    child: const Text('View All'),
                  ),
                ),
                
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final newsItem = news[index];
                      return Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 12),
                        child: InfoCard(
                          title: newsItem.title,
                          subtitle: newsItem.body,
                          onTap: () {
                            // TODO: Show full news item
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Chat Messages
                SectionHeader(
                  title: 'Recent Messages',
                  trailing: TextButton(
                    onPressed: () {
                      // TODO: Navigate to chat screen
                    },
                    child: const Text('View All'),
                  ),
                ),
                
                ...chatMessages.take(3).map((message) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: InfoCard(
                    title: message.senderName,
                    subtitle: message.message,
                    leadingWidget: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(message.avatarUrl),
                      child: message.avatarUrl.isEmpty 
                        ? Text(message.senderName[0])
                        : null,
                    ),
                    trailingWidget: Text(
                      _formatTime(message.timestamp),
                      style: AppTheme.descriptionStyle,
                    ),
                    onTap: () {
                      // TODO: Navigate to chat
                    },
                  ),
                )),

                const SizedBox(height: 24),

                // Quick Actions
                SectionHeader(title: 'Quick Actions'),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Training Dojo',
                              subtitle: 'Improve your stats',
                              leadingWidget: const Icon(
                                Icons.fitness_center,
                                color: AppTheme.chakraColor,
                              ),
                              onTap: () {
                                // TODO: Navigate to training dojo
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoCard(
                              title: 'Missions',
                              subtitle: 'Take on new challenges',
                              leadingWidget: const Icon(
                                Icons.assignment,
                                color: AppTheme.attackColor,
                              ),
                              onTap: () {
                                // TODO: Navigate to missions
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Inventory',
                              subtitle: 'Manage your items',
                              leadingWidget: const Icon(
                                Icons.inventory,
                                color: AppTheme.defenseColor,
                              ),
                              onTap: () {
                                // TODO: Navigate to inventory
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoCard(
                              title: 'Village Hub',
                              subtitle: 'Explore the village',
                              leadingWidget: const Icon(
                                Icons.business,
                                color: AppTheme.staminaColor,
                              ),
                              onTap: () {
                                // TODO: Navigate to village hub
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // Bottom padding for navigation bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  int _getMaxHP(PlayerStats stats) {
    return 80 + 20 * stats.level + 6 * stats.str + 2 * stats.wil;
  }

  int _getCurrentHP(PlayerStats stats) {
    return stats.currentHP ?? _getMaxHP(stats);
  }
}