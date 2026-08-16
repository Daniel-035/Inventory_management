import 'package:flutter/material.dart';

class AppColors {
  // Main background colors
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF1E293B);    // Slate 800
  static const Color cardDark = Color(0xFF334155);       // Slate 700
  static const Color cardGlass = Color(0x33334155);      // Semi-transparent

  // Accent Gradients
  static const Color primary = Color(0xFF6366F1);        // Indigo 500
  static const Color primaryAccent = Color(0xFF818CF8);  // Indigo 400
  static const Color secondary = Color(0xFF0EA5E9);      // Sky 500
  static const Color accentTeal = Color(0xFF14B8A6);      // Teal 500

  // Status indicators
  static const Color success = Color(0xFF10B981);        // Emerald 500
  static const Color warning = Color(0xFFF59E0B);        // Amber 500
  static const Color error = Color(0xFFEF4444);          // Red 500
  static const Color info = Color(0xFF3B82F6);           // Blue 500

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);    // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8);  // Slate 400
  static const Color textMuted = Color(0xFF64748B);      // Slate 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x801E293B), Color(0x400F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
