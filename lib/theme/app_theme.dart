import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF6C5CE7);
  static const accent = Color(0xFFFFC048);
  static const background = Color(0xFFF8F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF8E8E9A);
  static const cardBorder = Color(0xFFE8E8F0);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF0F0F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
      prefixIconColor: textSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
