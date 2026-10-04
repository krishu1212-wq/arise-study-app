import 'package:flutter/material.dart';

class AriseColors {
  static const Color background = Color(0xFF050814);
  static const Color cardBg = Color(0xFF0A1226);
  static const Color cardBgLight = Color(0xFF0E1A38);
  
  // Neon Accents
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonBlue = Color(0xFF2563EB);
  static const Color neonGold = Color(0xFFFFB703);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color neonRed = Color(0xFFF43F5E);
  static const Color neonGreen = Color(0xFF10B981);

  // Text
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textCyan = Color(0xFF67E8F9);
}

class AriseGlows {
  static BoxDecoration cyanBorderBox({double borderRadius = 16}) {
    return BoxDecoration(
      color: AriseColors.cardBg.withOpacity(0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AriseColors.neonCyan.withOpacity(0.35), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: AriseColors.neonCyan.withOpacity(0.18),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration goldBorderBox({double borderRadius = 16}) {
    return BoxDecoration(
      color: AriseColors.cardBg.withOpacity(0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AriseColors.neonGold.withOpacity(0.4), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: AriseColors.neonGold.withOpacity(0.2),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration purpleBorderBox({double borderRadius = 16}) {
    return BoxDecoration(
      color: AriseColors.cardBg.withOpacity(0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AriseColors.neonPurple.withOpacity(0.4), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: AriseColors.neonPurple.withOpacity(0.22),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
