import 'package:flutter/material.dart';

/// App color constants based on Stitch AI designs
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF38E07B);
  static const Color primaryDark = Color(0xFF2BC266);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0A0F0C);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color cardDark = Color(0xFF161D19);

  // Accent Colors
  static const Color accentRed = Color(0xFFC62828);
  static const Color freshRed = Color(0xFFE63946);
  static const Color brandRed = Color(0xFFFF4B4B);

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textDarkGrey = Color(0xFF616161);

  // Category Colors
  static const Color categoryUnselected = Color(0xFF2A2A2A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Order Status Colors (Stitch design)
  static const Color statusOrange = Color(0xFFF59E0B);
  static const Color statusBlue = Color(0xFF3B82F6);
  static const Color statusGreen = Color(0xFF10B981);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, cardDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
