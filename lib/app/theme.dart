import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Background colors
  static const Color background = Color(0xFF1B1F38);
  static const Color cardBackground = Color(0xFF2A2F4F);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0AEC0);
  
  // Stat colors
  static const Color attack = Color(0xFFE63946);
  static const Color defense = Color(0xFF5E60CE);
  static const Color chakra = Color(0xFF48CAE4);
  static const Color stamina = Color(0xFF06D6A0);
  
  // Legacy color mappings for compatibility
  static const Color primaryColor = background;
  static const Color secondaryColor = background;
  static const Color accentColor = chakra;
  static const Color surfaceColor = cardBackground;
  static const Color cardColor = cardBackground;
  static const Color chakraColor = chakra;
  static const Color staminaColor = stamina;
  static const Color attackColor = attack;
  static const Color defenseColor = defense;
  static const Color hpColor = attack;
  static const Color ryoColor = Color(0xFFFFD700);
  static const Color speedColor = Color(0xFF00B5D8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: chakra,
        secondary: chakra,
        surface: cardBackground,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22.4, // 1.4rem
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          // Headings (h1, h2, h3, .title)
          headlineLarge: GoogleFonts.poppins(
            fontSize: 22.4, // 1.4rem
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22.4, // 1.4rem
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: textPrimary,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22.4, // 1.4rem
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: textPrimary,
          ),
          // Stat Labels
          titleLarge: GoogleFonts.inter(
            fontSize: 17.6, // 1.1rem
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 17.6, // 1.1rem
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          // Stat Values
          titleSmall: GoogleFonts.inter(
            fontSize: 16, // 1rem
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
          // Body text
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14.4, // 0.9rem
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: chakra,
          foregroundColor: textPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 19.2, vertical: 9.6), // 0.6rem 1.2rem
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: chakra),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 19.2, vertical: 9.6), // 0.6rem 1.2rem
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: chakra,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBackground,
        labelStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: textSecondary,
        thickness: 1,
      ),
    );
  }

  // Gradient backgrounds for special effects
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      cardBackground,
      background,
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      background,
      cardBackground,
    ],
  );

  // Box shadows with enhanced styling
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: chakra.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Enhanced card shadow with glow effect
  static List<BoxShadow> get cardGlowShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: chakra.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 0),
    ),
  ];

  // Progress bar glow effect
  static List<BoxShadow> get progressBarGlow => [
    BoxShadow(
      color: chakra.withValues(alpha: 0.4),
      blurRadius: 8,
      offset: const Offset(0, 0),
    ),
  ];

  // Hover glow effect for interactive elements
  static List<BoxShadow> get hoverGlow => [
    BoxShadow(
      color: chakra.withValues(alpha: 0.2),
      blurRadius: 15,
      offset: const Offset(0, 0),
    ),
  ];

  // Custom text styles for easy access
  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 22.4, // 1.4rem
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: textPrimary,
  );

  static TextStyle get statLabelStyle => GoogleFonts.inter(
    fontSize: 17.6, // 1.1rem
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get statValueStyle => GoogleFonts.inter(
    fontSize: 16, // 1rem
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );

  static TextStyle get descriptionStyle => GoogleFonts.inter(
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static TextStyle get buttonStyle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
}
