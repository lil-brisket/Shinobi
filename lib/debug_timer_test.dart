import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/providers.dart';
import 'models/timer.dart';
import 'features/auth/providers/auth_provider.dart';

class DebugTimerTest extends ConsumerWidget {
  const DebugTimerTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timersProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Timer Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Auth State:', style: Theme.of(context).textTheme.headlineSmall),
            Text('Is Authenticated: ${authState.isAuthenticated}'),
            Text('User ID: ${authState.userId ?? "null"}'),
            Text('Username: ${authState.username ?? "null"}'),
            const SizedBox(height: 20),
            
            Text('Timers:', style: Theme.of(context).textTheme.headlineSmall),
            Text('Timer Count: ${timers.length}'),
            const SizedBox(height: 10),
            
            if (timers.isEmpty)
              const Text('No timers found')
            else
              ...timers.map((timer) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${timer.id}'),
                      Text('Title: ${timer.title}'),
                      Text('Type: ${timer.type}'),
                      Text('Start Time: ${timer.startTime}'),
                      Text('Duration: ${timer.duration}'),
                      Text('Remaining: ${timer.remainingTime}'),
                      Text('Is Completed: ${timer.isCompleted}'),
                      Text('Metadata: ${timer.metadata}'),
                    ],
                  ),
                ),
              )),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Test creating a timer
                final testTimer = GameTimer(
                  id: 'test_${DateTime.now().millisecondsSinceEpoch}',
                  title: 'Test Training',
                  type: TimerType.training,
                  startTime: DateTime.now(),
                  duration: const Duration(minutes: 1),
                  metadata: {'statType': 'strength', 'statIncrease': 1},
                );
                
                try {
                  await ref.read(timersProvider.notifier).addTimer(testTimer);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test timer added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding timer: $e')),
                  );
                }
              },
              child: const Text('Add Test Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
