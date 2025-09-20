import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/info_card.dart';
import '../../app/theme.dart';

class DuelingAcademyScreen extends ConsumerStatefulWidget {
  const DuelingAcademyScreen({super.key});

  @override
  ConsumerState<DuelingAcademyScreen> createState() => _DuelingAcademyScreenState();
}

class _DuelingAcademyScreenState extends ConsumerState<DuelingAcademyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<DuelChallenge> _pendingChallenges = [];
  final List<String> _mockPlayers = [
    'Sasuke_Uchiha',
    'Sakura_Haruno',
    'Kakashi_Hatake',
    'Naruto_Uzumaki',
    'Hinata_Hyuga',
    'Shikamaru_Nara',
    'Ino_Yamanaka',
    'Choji_Akimichi',
    'Neji_Hyuga',
    'Rock_Lee',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dueling Academy'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.attackColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.sports_kabaddi,
                          color: AppTheme.attackColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dueling Arena',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Challenge other players to duels',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pending Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                if (_pendingChallenges.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No pending challenges',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: _pendingChallenges.length,
                      itemBuilder: (context, index) {
                        final challenge = _pendingChallenges[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: _buildChallengeCard(context, challenge),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Challenge Player',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search player name...',
                          hintStyle: const TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.accentColor),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white60,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _mockPlayers
                              .where((player) => player
                                  .toLowerCase()
                                  .contains(_searchController.text.toLowerCase()))
                              .length,
                          itemBuilder: (context, index) {
                            final filteredPlayers = _mockPlayers
                                .where((player) => player
                                    .toLowerCase()
                                    .contains(_searchController.text.toLowerCase()))
                                .toList();
                            final player = filteredPlayers[index];
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: _buildPlayerCard(context, player),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext context, DuelChallenge challenge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: challenge.isFromMe ? AppTheme.attackColor.withValues(alpha: 0.3) : AppTheme.chakraColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (challenge.isFromMe ? AppTheme.attackColor : AppTheme.chakraColor).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              challenge.isFromMe ? Icons.send : Icons.sports_martial_arts,
              color: challenge.isFromMe ? AppTheme.attackColor : AppTheme.chakraColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.isFromMe ? 'Challenge to ${challenge.opponentName}' : 'Challenge from ${challenge.opponentName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  challenge.status,
                  style: TextStyle(
                    color: challenge.isFromMe ? AppTheme.attackColor : AppTheme.chakraColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!challenge.isFromMe && challenge.status == 'Pending')
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _acceptChallenge(challenge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.staminaColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _declineChallenge(challenge),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.hpColor,
                    side: const BorderSide(color: AppTheme.hpColor),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Decline'),
                ),
              ],
            )
          else if (challenge.isFromMe && challenge.status == 'Pending')
            OutlinedButton(
              onPressed: () => _cancelChallenge(challenge),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.hpColor,
                side: const BorderSide(color: AppTheme.hpColor),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Cancel'),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, String playerName) {
    return InfoCard(
      title: playerName,
      subtitle: 'Click to send duel challenge',
      leadingWidget: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          playerName[0].toUpperCase(),
          style: const TextStyle(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      trailingWidget: ElevatedButton(
        onPressed: () => _sendChallenge(playerName),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.attackColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: const Text('Challenge'),
      ),
    );
  }

  void _sendChallenge(String playerName) {
    final challenge = DuelChallenge(
      opponentName: playerName,
      isFromMe: true,
      status: 'Pending',
      sentAt: DateTime.now(),
    );
    
    setState(() {
      _pendingChallenges.add(challenge);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge sent to $playerName!'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }

  void _acceptChallenge(DuelChallenge challenge) {
    setState(() {
      challenge.status = 'Accepted';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge accepted! Duel system coming soon!'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }

  void _declineChallenge(DuelChallenge challenge) {
    setState(() {
      _pendingChallenges.remove(challenge);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge declined'),
        backgroundColor: AppTheme.hpColor,
      ),
    );
  }

  void _cancelChallenge(DuelChallenge challenge) {
    setState(() {
      _pendingChallenges.remove(challenge);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge cancelled'),
        backgroundColor: AppTheme.hpColor,
      ),
    );
  }
}

class DuelChallenge {
  final String opponentName;
  final bool isFromMe;
  String status;
  final DateTime sentAt;

  DuelChallenge({
    required this.opponentName,
    required this.isFromMe,
    required this.status,
    required this.sentAt,
  });
}
