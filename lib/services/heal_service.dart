import '../models/player.dart';
import '../models/stats.dart';

class HealService {
  // Base CP/SP cost per HP healed
  static const double cpCostPerHp = 2.0; // 2 CP per HP healed
  static const double spCostPerHp = 2.0; // 2 SP per HP healed
  
  // Base XP reward per HP healed
  static const double xpPerHp = 0.1; // 0.1 XP per HP healed

  /// Heal a player and return the updated player with new stats and profession XP
  static Player healPlayer(Player healer, Player target) {
    // Check if target needs healing
    if (target.stats.hp >= target.stats.maxHp) {
      throw TargetAlreadyFullHealthException('Target is already at full health');
    }
    
    // Calculate actual heal amount (always heal to max)
    final actualHealAmount = target.stats.maxHp - target.stats.hp;
    
    // Calculate costs based on healing amount with medical ninja cost reduction
    final costReduction = healer.medNinja.costReduction;
    final baseCpCost = (actualHealAmount * cpCostPerHp);
    final baseSpCost = (actualHealAmount * spCostPerHp);
    final cpCost = (baseCpCost * (1 - costReduction)).round();
    final spCost = (baseSpCost * (1 - costReduction)).round();
    
    // Check if healer has enough resources
    if (healer.stats.cp < cpCost || healer.stats.sp < spCost) {
      throw InsufficientResourcesException('Not enough CP or SP to perform healing');
    }
    
    // Calculate XP reward based on healing amount
    final xpReward = (actualHealAmount * xpPerHp).round();
    
    // Consume resources from healer
    final newHealerStats = healer.stats
        .updateCP(healer.stats.cp - cpCost)
        .updateSP(healer.stats.sp - spCost);
    
    // Add profession XP to healer
    final newMedNinja = healer.medNinja.addXp(xpReward);
    
    // Return updated healer
    return healer.copyWith(
      stats: newHealerStats,
      medNinja: newMedNinja,
    );
  }
  
  /// Get healing information without actually performing the heal
  static HealingInfo getHealingInfo(Player healer, Player target) {
    // Calculate actual heal amount (always heal to max)
    final actualHealAmount = target.stats.maxHp - target.stats.hp;
    
    // Calculate costs based on healing amount with medical ninja cost reduction
    final costReduction = healer.medNinja.costReduction;
    final baseCpCost = (actualHealAmount * cpCostPerHp);
    final baseSpCost = (actualHealAmount * spCostPerHp);
    final cpCost = (baseCpCost * (1 - costReduction)).round();
    final spCost = (baseSpCost * (1 - costReduction)).round();
    
    // Calculate XP reward based on healing amount
    final xpReward = (actualHealAmount * xpPerHp).round();
    
    final canHeal = healer.stats.cp >= cpCost && 
                   healer.stats.sp >= spCost && 
                   target.stats.hp < target.stats.maxHp;
    
    return HealingInfo(
      healAmount: actualHealAmount,
      cpCost: cpCost,
      spCost: spCost,
      xpReward: xpReward,
      canHeal: canHeal,
      reason: canHeal ? null : _getCannotHealReason(healer, target, cpCost, spCost),
    );
  }
  
  static String? _getCannotHealReason(Player healer, Player target, int cpCost, int spCost) {
    if (healer.stats.cp < cpCost) {
      return 'Not enough CP (need $cpCost, have ${healer.stats.cp})';
    }
    if (healer.stats.sp < spCost) {
      return 'Not enough SP (need $spCost, have ${healer.stats.sp})';
    }
    if (target.stats.hp >= target.stats.maxHp) {
      return 'Target is already at full health';
    }
    return null;
  }
}

class HealingInfo {
  final int healAmount;
  final int cpCost;
  final int spCost;
  final int xpReward;
  final bool canHeal;
  final String? reason;
  
  const HealingInfo({
    required this.healAmount,
    required this.cpCost,
    required this.spCost,
    required this.xpReward,
    required this.canHeal,
    this.reason,
  });
}

class InsufficientResourcesException implements Exception {
  final String message;
  InsufficientResourcesException(this.message);
  
  @override
  String toString() => 'InsufficientResourcesException: $message';
}

class TargetAlreadyFullHealthException implements Exception {
  final String message;
  TargetAlreadyFullHealthException(this.message);
  
  @override
  String toString() => 'TargetAlreadyFullHealthException: $message';
}
