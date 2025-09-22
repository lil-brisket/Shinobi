class StatsUtils {
  // Constants for stat caps
  static const int combatStatCap = 500000;    // Max for combat stats (500k)
  static const int baseStatCap = 250000;      // Max for base stats (250k)
  
  // Offense caps based on priority (tier restrictions)
  // These caps are set so that only the highest stat can reach tier 5
  static const int mainOffenseCap = 500000;     // Main offense - can reach tier 5 (500k)
  static const int secondaryOffenseCap = 250000; // Secondary offense - max tier 4 (250k) 
  static const int tertiaryOffenseCap = 150000;  // Tertiary offense - max tier 3 (150k)
  static const int quaternaryOffenseCap = 50000; // Quaternary offense - max tier 1 (50k)

  // Tier thresholds (updated)
  static const Map<String, double> tierThresholds = {
    'T1': 0.20,    // 0 – 20%
    'T2': 0.40,    // 21 – 40%
    'T3': 0.60,    // 41 – 60%
    'T4': 0.80,    // 61 – 80%
    'T5': 1.00,    // 81 – 100%
  };

  /// Format number with thousands separators and two decimal places
  static String formatNum(double n) {
    return n.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Clamp a number between min and max values
  static double clamp(double n, double min, double max) {
    if (n < min) return min;
    if (n > max) return max;
    return n;
  }

  /// Calculate percentage of value relative to cap (0-100)
  static double pct(double value, double cap) {
    if (cap <= 0) return 0;
    return clamp((value / cap) * 100, 0, 100);
  }

  /// Determine tier based on value and cap using the tier thresholds
  static int tierFrom(double value, double cap) {
    if (cap <= 0) return 1;
    
    final percentage = value / cap;
    
    if (percentage <= tierThresholds['T1']!) return 1;
    if (percentage <= tierThresholds['T2']!) return 2;
    if (percentage <= tierThresholds['T3']!) return 3;
    if (percentage <= tierThresholds['T4']!) return 4;
    return 5;
  }

  /// Determine offense stat priority order based on current values
  static Map<String, String> getOffensePriority(Map<String, int> offenseStats) {
    // Sort offense stats by value (descending)
    final sortedStats = offenseStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final priority = <String, String>{};
    final priorities = ['main', 'secondary', 'tertiary', 'quaternary'];
    
    for (int i = 0; i < sortedStats.length && i < priorities.length; i++) {
      priority[sortedStats[i].key] = priorities[i];
    }
    
    return priority;
  }

  /// Get the appropriate cap for a stat based on its key and type
  static double capFor(String key, String type, {String? offensePriority}) {
    // Base stats use base cap
    if (type == 'base') {
      return baseStatCap.toDouble();
    }
    
    // Defence stats use 500K cap without restrictions
    if (type == 'defence') {
      return 500000.0; // 500K cap for all defense stats
    }
    
    // Combat stats (offences) use priority-based caps
    if (type == 'combat') {
      switch (offensePriority) {
        case 'main':
          return mainOffenseCap.toDouble();
        case 'secondary':
          return secondaryOffenseCap.toDouble();
        case 'tertiary':
          return tertiaryOffenseCap.toDouble();
        case 'quaternary':
          return quaternaryOffenseCap.toDouble();
        default:
          // Default to main offense cap for backwards compatibility
          return mainOffenseCap.toDouble();
      }
    }
    
    // Default to combat cap
    return combatStatCap.toDouble();
  }

  /// Get offense stats from PlayerStats
  static Map<String, int> getOffenseStats(int nin, int gen, int buk, int tai) {
    return {
      'nin': nin,
      'gen': gen,
      'buk': buk,
      'tai': tai,
    };
  }

  /// Calculate tier with offense priority restrictions
  static int tierFromWithPriority(double value, String statKey, Map<String, int> offenseStats) {
    // All offense stats use the same base cap (500k) for tier calculation
    // The priority caps are just the maximum values they can reach
    const double offenseBaseCap = 500000.0;
    
    // Calculate tier based on the full offense cap
    return tierFrom(value, offenseBaseCap);
  }

  /// Calculate tier for offense stat with automatic priority detection
  static int tierForOffenseStat(int value, String statKey, int nin, int gen, int buk, int tai) {
    final offenseStats = getOffenseStats(nin, gen, buk, tai);
    return tierFromWithPriority(value.toDouble(), statKey, offenseStats);
  }

  /// Calculate percentage progress within the current tier for offense stats
  static double percentageWithinTier(int value, String statKey, int nin, int gen, int buk, int tai) {
    const double baseCap = 500000.0;
    final currentTier = tierForOffenseStat(value, statKey, nin, gen, buk, tai);
    
    // Get tier range boundaries
    final currentThreshold = currentTier == 1 ? 0.0 : tierThresholds['T${currentTier - 1}']! * baseCap;
    final nextThreshold = tierThresholds['T$currentTier']! * baseCap;
    
    // Calculate progress within current tier range
    final tierRange = nextThreshold - currentThreshold;
    if (tierRange <= 0) return 100.0; // Max tier reached
    
    final progressInTier = (value - currentThreshold) / tierRange;
    return (progressInTier * 100).clamp(0.0, 100.0);
  }

  /// Calculate percentage progress within the current tier for defense stats
  static double percentageWithinTierDefense(int value, String statKey) {
    const double baseCap = 500000.0;
    final currentTier = tierFrom(value.toDouble(), baseCap);
    
    // Get tier range boundaries
    final currentThreshold = currentTier == 1 ? 0.0 : tierThresholds['T${currentTier - 1}']! * baseCap;
    final nextThreshold = tierThresholds['T$currentTier']! * baseCap;
    
    // Calculate progress within current tier range
    final tierRange = nextThreshold - currentThreshold;
    if (tierRange <= 0) return 100.0; // Max tier reached
    
    final progressInTier = (value - currentThreshold) / tierRange;
    return (progressInTier * 100).clamp(0.0, 100.0);
  }
  
  /// Format large numbers with K/M suffixes for display
  static String formatStatValue(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toString();
    }
  }

  /// Format numbers as whole numbers with commas
  static String formatWholeNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format percentage for display (0-100)
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }
}
