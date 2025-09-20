import '../models/village.dart';

class VillageConstants {
  static const List<Village> allVillages = [
    Village(
      id: 'willowshade',
      name: 'Willowshade Village',
      emblem: '🌿',
      tileX: 10,
      tileY: 15,
      description: 'A village hidden among ancient willow trees, known for its natural healing techniques and connection to nature.',
    ),
    Village(
      id: 'ashpeak',
      name: 'Ashpeak Village',
      emblem: '🔥',
      tileX: 25,
      tileY: 8,
      description: 'Built within the peaks of volcanic mountains, this village masters fire-based techniques and volcanic ash manipulation.',
    ),
    Village(
      id: 'stormvale',
      name: 'Stormvale Village',
      emblem: '⚡',
      tileX: 5,
      tileY: 25,
      description: 'A village that harnesses the power of storms, specializing in lightning techniques and weather manipulation.',
    ),
    Village(
      id: 'snowhollow',
      name: 'Snowhollow Village',
      emblem: '❄️',
      tileX: 30,
      tileY: 20,
      description: 'Hidden in the frozen valleys, this village excels in ice techniques and survival in extreme cold conditions.',
    ),
    Village(
      id: 'shadowfen',
      name: 'Shadowfen Village',
      emblem: '🌑',
      tileX: 15,
      tileY: 30,
      description: 'A mysterious village in the shadowy wetlands, known for stealth techniques and shadow manipulation arts.',
    ),
  ];

  static Village? getVillageById(String id) {
    try {
      return allVillages.firstWhere((village) => village.id == id);
    } catch (e) {
      return null;
    }
  }

  static Village? getVillageByName(String name) {
    try {
      return allVillages.firstWhere((village) => village.name == name);
    } catch (e) {
      return null;
    }
  }
}
