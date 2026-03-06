import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static const _seedColor = Color(0xFF6750A4);

  static final _textTheme = GoogleFonts.plusJakartaSansTextTheme();

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    final baseTextTheme = brightness == Brightness.dark
        ? _textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)
        : _textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
    );
  }

  static BoxDecoration get glassmorphism => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      );

  static BoxDecoration get cardGradient => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF1A237E)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withValues(alpha: 0.3),
            blurRadius: 20,
          ),
        ],
      );
}
