// lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF02040F);
  static const Color accentColor = Color(0xFF00FFD5); // Neon Teal/Cyan
  static const Color secondaryColor = Color(0xFF9F70FD); // Neon Purple
  static const Color tertiaryColor = Color(0xFF42A5F5); // Neon Blue
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);

  // Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryColor,
      background: primaryColor,
    ),
    textTheme: GoogleFonts.orbitronTextTheme(
      ThemeData.dark().textTheme.copyWith(
        bodyLarge: const TextStyle(color: Colors.white70),
        bodyMedium: const TextStyle(color: Colors.white60),
        headlineLarge: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor.withOpacity(0.5),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.rajdhani(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[900]?.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[800]!, width: 1),
      ),
    ),
  );
}