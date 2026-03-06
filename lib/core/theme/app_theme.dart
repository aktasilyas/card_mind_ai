import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static const duoGreen = Color(0xFF58CC02);
  static const duoBlue = Color(0xFF1CB0F6);
  static const duoOrange = Color(0xFFFF9600);
  static const duoRed = Color(0xFFFF4B4B);

  static final _textTheme = GoogleFonts.nunitoTextTheme();

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: duoGreen,
      brightness: brightness,
    );
    final baseTextTheme = brightness == Brightness.dark
        ? _textTheme.apply(
            bodyColor: Colors.white, displayColor: Colors.white)
        : _textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.12)
                : colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        color: brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: duoGreen.withValues(alpha: 0.2),
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

  static const List<List<Color>> deckGradients = [
    [Color(0xFF58CC02), Color(0xFF46A302)],
    [Color(0xFF1CB0F6), Color(0xFF1899D6)],
    [Color(0xFFFF9600), Color(0xFFE08600)],
    [Color(0xFFFF4B4B), Color(0xFFEA2B2B)],
    [Color(0xFFCE82FF), Color(0xFFAF5CF7)],
    [Color(0xFF2B70C9), Color(0xFF1F5CA1)],
  ];
}
