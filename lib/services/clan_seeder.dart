import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/villages.dart';

class ClanSeeder {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Clan data for each village
  static const Map<String, List<Map<String, dynamic>>> villageClans = {
    'willowshade': [
      {
        'name': 'Willow Guardians',
        'description': 'Protectors of the ancient willow groves, masters of nature-based techniques and healing arts.',
        'emblem_url': '🌿',
        'score': 1250,
      },
      {
        'name': 'Leaf Shadows',
        'description': 'Stealthy ninja who move like shadows through the forest canopy, specializing in camouflage and tracking.',
        'emblem_url': '🍃',
        'score': 980,
      },
      {
        'name': 'Root Warriors',
        'description': 'Ground-based fighters who draw strength from the earth, known for their defensive techniques and endurance.',
        'emblem_url': '🌳',
        'score': 1100,
      },
    ],
    'ashpeak': [
      {
        'name': 'Volcano Vanguard',
        'description': 'Elite warriors who harness the power of volcanic fire, masters of explosive techniques and heat resistance.',
        'emblem_url': '🌋',
        'score': 1400,
      },
      {
        'name': 'Ember Strikers',
        'description': 'Swift attackers who strike like lightning, using fire-based speed techniques and precision combat.',
        'emblem_url': '🔥',
        'score': 1150,
      },
      {
        'name': 'Ash Storm',
        'description': 'Mysterious clan that controls volcanic ash and smoke, specializing in area denial and battlefield control.',
        'emblem_url': '💨',
        'score': 1050,
      },
    ],
    'stormvale': [
      {
        'name': 'Thunder Lords',
        'description': 'Masters of lightning techniques, capable of calling down storms and controlling electrical energy.',
        'emblem_url': '⚡',
        'score': 1350,
      },
      {
        'name': 'Wind Riders',
        'description': 'Swift warriors who ride the winds, specializing in aerial combat and wind-based mobility techniques.',
        'emblem_url': '💨',
        'score': 1200,
      },
      {
        'name': 'Storm Callers',
        'description': 'Weather manipulators who can summon rain, fog, and storms to aid their allies and hinder enemies.',
        'emblem_url': '⛈️',
        'score': 1000,
      },
    ],
    'snowhollow': [
      {
        'name': 'Ice Guardians',
        'description': 'Defenders of the frozen valleys, masters of ice techniques and survival in extreme cold conditions.',
        'emblem_url': '❄️',
        'score': 1300,
      },
      {
        'name': 'Frost Wolves',
        'description': 'Pack-based fighters who hunt in the snow, known for their teamwork and tracking abilities.',
        'emblem_url': '🐺',
        'score': 1100,
      },
      {
        'name': 'Crystal Shards',
        'description': 'Elite warriors who forge weapons from ice crystals, specializing in ice-based weapon techniques.',
        'emblem_url': '🔮',
        'score': 950,
      },
    ],
    'shadowfen': [
      {
        'name': 'Shadow Assassins',
        'description': 'Masters of stealth and assassination, moving unseen through the shadowy wetlands.',
        'emblem_url': '🌑',
        'score': 1450,
      },
      {
        'name': 'Mist Walkers',
        'description': 'Mysterious ninja who blend with the fog, specializing in illusion techniques and psychological warfare.',
        'emblem_url': '🌫️',
        'score': 1250,
      },
      {
        'name': 'Bog Spirits',
        'description': 'Ancient warriors who commune with the spirits of the wetlands, using dark magic and necromancy.',
        'emblem_url': '👻',
        'score': 1150,
      },
    ],
  };

  Future<void> seedClans() async {
    try {
      print('Starting clan seeding...');

      for (final village in VillageConstants.allVillages) {
        final clans = villageClans[village.id];
        if (clans == null) continue;

        print('Seeding clans for ${village.name}...');

        for (final clanData in clans) {
          // Check if clan already exists
          final existingClan = await _supabase
              .from('clans')
              .select('id')
              .eq('name', clanData['name'])
              .eq('village_id', village.id)
              .maybeSingle();

          if (existingClan != null) {
            print('Clan ${clanData['name']} already exists, skipping...');
            continue;
          }

          // Create the clan
          final clan = await _supabase.from('clans').insert({
            'name': clanData['name'],
            'description': clanData['description'],
            'village_id': village.id,
            'emblem_url': clanData['emblem_url'],
            'score': clanData['score'],
            'leader_id': null, // Will be set when a leader joins
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }).select().single();

          print('Created clan: ${clanData['name']} in ${village.name}');
        }
      }

      print('Clan seeding completed successfully!');
    } catch (e) {
      print('Error seeding clans: $e');
      rethrow;
    }
  }

  Future<void> clearAllClans() async {
    try {
      print('Clearing all clans...');
      
      // Delete clan members first (due to foreign key constraints)
      await _supabase.from('clan_members').delete().neq('id', '');
      
      // Delete clan applications
      await _supabase.from('clan_applications').delete().neq('id', '');
      
      // Delete clan board posts
      await _supabase.from('clan_board_posts').delete().neq('id', '');
      
      // Delete clans
      await _supabase.from('clans').delete().neq('id', '');
      
      print('All clans cleared successfully!');
    } catch (e) {
      print('Error clearing clans: $e');
      rethrow;
    }
  }
}
