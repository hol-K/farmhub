import 'package:flutter/material.dart';

/// Couleurs, tailles et thème de l'app. Interface simple : gros boutons, gros texte.
abstract final class AppTheme {
  // Couleurs.
  static const primary = Color(0xFF2E7D32);
  static const pending = Color(0xFFEF6C00); // « En attente d'envoi »
  static const published = Color(0xFF2E7D32); // « Publié »
  static const offline = Color(0xFF616161);

  // Dimensions.
  static const spacing = 16.0;
  static const buttonHeight = 56.0;
  static const radius = 12.0;
  static const iconSize = 32.0;

  static final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
  static const _buttonText = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(buttonHeight),
        textStyle: _buttonText,
        shape: _shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(buttonHeight),
        textStyle: _buttonText,
        shape: _shape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
      contentPadding: const EdgeInsets.all(spacing),
    ),
  );
}
