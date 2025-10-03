
/// Centralized theme tokens for consistent design system
/// All widgets should consume these tokens instead of hardcoded values
class AppTokens {
  // Private constructor to prevent instantiation
  AppTokens._();

  // Spacing tokens
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  // Border radius tokens
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 20.0;

  // Elevation tokens
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXl = 12.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Breakpoints for responsive design
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  // Grid system constants
  static const int gridRows = 5;
  static const int gridCols = 12;
  static const int gridRowsPortrait = 10;
  static const int gridColsPortrait = 5;

  // Combat system constants
  static const int defaultAPMax = 100;
  static const int moveAPCost = 20;
  static const int punchAPCost = 20;
  static const int healAPCost = 20;
  static const int fleeAPCost = 30;

  // Stat caps
  static const int baseStatCap = 250000;
  static const int combatStatCap = 500000;

  // Accessibility
  static const double minTouchTarget = 44.0;
  static const double maxContentWidth = 1200.0;
}

/// Extension for easy access to spacing values
extension SpacingExtension on double {
  static const double xs = AppTokens.spacingXs;
  static const double s = AppTokens.spacingS;
  static const double m = AppTokens.spacingM;
  static const double l = AppTokens.spacingL;
  static const double xl = AppTokens.spacingXl;
  static const double xxl = AppTokens.spacingXxl;
}

/// Extension for easy access to radius values
extension RadiusExtension on double {
  static const double s = AppTokens.radiusS;
  static const double m = AppTokens.radiusM;
  static const double l = AppTokens.radiusL;
  static const double xl = AppTokens.radiusXl;
}
