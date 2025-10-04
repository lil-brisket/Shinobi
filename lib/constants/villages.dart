import '../models/village.dart';

class VillageConstants {
  static const List<Village> allVillages = [
    Village(
      id: '550e8400-e29b-41d4-a716-446655440001',
      name: 'Willowshade Village',
      emblem: '🌿',
      tileX: 10,
      tileY: 15,
      description: 'A peaceful village known for its healing techniques',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440002',
      name: 'Firestorm Village',
      emblem: '🔥',
      tileX: 25,
      tileY: 8,
      description: 'A village of warriors specializing in fire techniques',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440003',
      name: 'Deepwater Village',
      emblem: '💧',
      tileX: 5,
      tileY: 25,
      description: 'A village hidden in the mist, masters of water',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440004',
      name: 'Iron Mountain Village',
      emblem: '⛰️',
      tileX: 30,
      tileY: 20,
      description: 'A village built into the mountains, earth specialists',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440005',
      name: 'Skywind Village',
      emblem: '🌪️',
      tileX: 15,
      tileY: 30,
      description: 'A floating village of wind masters',
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
