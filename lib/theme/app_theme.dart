import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _gray900 = Color(0xFF111827);
  static const _gray800 = Color(0xFF1F2937);
  static const _gray500 = Color(0xFF6B7280);
  static const _gray400 = Color(0xFF9CA3AF);
  static const _emerald600 = Color(0xFF059669);
  static const _emerald400 = Color(0xFF34D399);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: _gray900,
    colorScheme: const ColorScheme.dark(
      primary: _emerald400,
      secondary: _emerald600,
      surface: _gray800,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
            titleLarge: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            titleMedium: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _gray400,
            ),
            bodyLarge: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: const TextStyle(
              fontSize: 14,
              color: _gray400,
            ),
          ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _gray800,
      hintStyle: const TextStyle(color: _gray500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withAlpha(25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withAlpha(25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _emerald400),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
    ),
    cardTheme: CardTheme(
      color: _gray800.withAlpha(122),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.white,
      thickness: 1,
    ),
    iconTheme: IconThemeData(
      color: _emerald400.withAlpha(200),
      size: 20,
    ),
  );
}
