import 'package:flutter_test/flutter_test.dart';
import 'package:shogunx/utils/stats_utils.dart';

void main() {
  group('Tier System Tests', () {
    test('should calculate correct tiers for different stat levels', () {
      // Test Tier 1 (0-20%)
      expect(StatsUtils.tierFrom(1.0, 100.0), equals(1));
      expect(StatsUtils.tierFrom(20.0, 100.0), equals(1));
      
      // Test Tier 2 (21-40%)
      expect(StatsUtils.tierFrom(30.0, 100.0), equals(2));
      expect(StatsUtils.tierFrom(40.0, 100.0), equals(2));
      
      // Test Tier 3 (41-60%)
      expect(StatsUtils.tierFrom(50.0, 100.0), equals(3));
      expect(StatsUtils.tierFrom(60.0, 100.0), equals(3));
      
      // Test Tier 4 (61-80%)
      expect(StatsUtils.tierFrom(70.0, 100.0), equals(4));
      expect(StatsUtils.tierFrom(80.0, 100.0), equals(4));
      
      // Test Tier 5 (81-100%)
      expect(StatsUtils.tierFrom(90.0, 100.0), equals(5));
      expect(StatsUtils.tierFrom(100.0, 100.0), equals(5));
    });

    test('should calculate correct percentages', () {
      expect(StatsUtils.pct(20.0, 100.0), equals(20.0));
      expect(StatsUtils.pct(50.0, 100.0), equals(50.0));
      expect(StatsUtils.pct(75.0, 100.0), equals(75.0));
    });

    test('should get correct caps for different stat types', () {
      expect(StatsUtils.capFor('str', 'base'), equals(250000.0));
      expect(StatsUtils.capFor('nin', 'combat', offensePriority: 'main'), equals(500000.0));
      expect(StatsUtils.capFor('nin', 'defence'), equals(500000.0));
    });

    test('should determine offense priority correctly', () {
      final offenseStats = {'nin': 400000, 'gen': 200000, 'buk': 120000, 'tai': 40000};
      final priority = StatsUtils.getOffensePriority(offenseStats);
      
      expect(priority['nin'], equals('main'));
      expect(priority['gen'], equals('secondary'));
      expect(priority['buk'], equals('tertiary'));
      expect(priority['tai'], equals('quaternary'));
    });

    test('should enforce tier restrictions based on priority', () {
      // Test case from the image: nin=300k, gen=125k, buk=90k, tai=20k
      // All calculated against 500k cap: nin=60% (T3), gen=25% (T2), buk=18% (T1), tai=4% (T1)
      
      expect(StatsUtils.tierForOffenseStat(300000, 'nin', 300000, 125000, 90000, 20000), equals(3));
      expect(StatsUtils.tierForOffenseStat(125000, 'gen', 300000, 125000, 90000, 20000), equals(2));
      expect(StatsUtils.tierForOffenseStat(90000, 'buk', 300000, 125000, 90000, 20000), equals(1));
      expect(StatsUtils.tierForOffenseStat(20000, 'tai', 300000, 125000, 90000, 20000), equals(1));
    });

    test('should handle equal stat values correctly', () {
      // When two stats have the same high value, they both get the same tier
      // 300k / 500k = 60% = Tier 3
      expect(StatsUtils.tierForOffenseStat(300000, 'nin', 300000, 300000, 90000, 20000), equals(3));
      expect(StatsUtils.tierForOffenseStat(300000, 'gen', 300000, 300000, 90000, 20000), equals(3));
    });

    test('should work with different main stat choices', () {
      // Example 1: Taijutsu as main (highest value) - all calculated against 500k cap
      // tai=300k/500k=60% (T3), gen=120k/500k=24% (T2), nin=100k/500k=20% (T1), buk=24k/500k=5% (T1)
      expect(StatsUtils.tierForOffenseStat(300000, 'tai', 100000, 120000, 24000, 300000), equals(3));
      expect(StatsUtils.tierForOffenseStat(120000, 'gen', 100000, 120000, 24000, 300000), equals(2));
      expect(StatsUtils.tierForOffenseStat(100000, 'nin', 100000, 120000, 24000, 300000), equals(1));
      expect(StatsUtils.tierForOffenseStat(24000, 'buk', 100000, 120000, 24000, 300000), equals(1));
      
      // Example 2: Genjutsu as main (highest value)
      // gen=300k/500k=60% (T3), tai=120k/500k=24% (T2), nin=100k/500k=20% (T1), buk=24k/500k=5% (T1)
      expect(StatsUtils.tierForOffenseStat(300000, 'gen', 100000, 300000, 24000, 120000), equals(3));
      expect(StatsUtils.tierForOffenseStat(120000, 'tai', 100000, 300000, 24000, 120000), equals(2));
      expect(StatsUtils.tierForOffenseStat(100000, 'nin', 100000, 300000, 24000, 120000), equals(1));
      expect(StatsUtils.tierForOffenseStat(24000, 'buk', 100000, 300000, 24000, 120000), equals(1));
      
      // Example 3: Bukijutsu as main (highest value)
      // buk=300k/500k=60% (T3), gen=120k/500k=24% (T2), nin=100k/500k=20% (T1), tai=24k/500k=5% (T1)
      expect(StatsUtils.tierForOffenseStat(300000, 'buk', 100000, 120000, 300000, 24000), equals(3));
      expect(StatsUtils.tierForOffenseStat(120000, 'gen', 100000, 120000, 300000, 24000), equals(2));
      expect(StatsUtils.tierForOffenseStat(100000, 'nin', 100000, 120000, 300000, 24000), equals(1));
      expect(StatsUtils.tierForOffenseStat(24000, 'tai', 100000, 120000, 300000, 24000), equals(1));
    });

    test('should format numbers correctly', () {
      expect(StatsUtils.formatNum(1234.56), equals('1,234.56'));
      expect(StatsUtils.formatNum(100.0), equals('100.00'));
    });
  });
}
