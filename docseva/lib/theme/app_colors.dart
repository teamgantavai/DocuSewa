import 'package:flutter/material.dart';

/// Design system color palette for DocuSewa.
/// Teal & DigiLocker-inspired theme with full dark mode support.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // DocuSewa Brand Colors (Teal Palette)
  // ---------------------------------------------------------------------------

  /// Primary Teal
  static const Color tealPrimary = Color(0xFF0D9488);
  static const Color tealHover = Color(0xFF0F766E);
  static const Color tealDark = Color(0xFF115E59);
  static const Color tealLight = Color(0xFF99F6E4);
  static const Color tealSubtle = Color(0xFFCCFBF1);
  static const Color tealSurface = Color(0xFFF0FDFA);

  /// Backwards compatibility / aliases
  static const Color trustBlue = tealPrimary;
  static const Color trustBlueDark = tealHover;
  static const Color trustBlueLight = tealLight;
  static const Color sapphireBlue = tealPrimary;
  static const Color lightSapphire = tealLight;
  static const Color royalBlue = tealDark;
  static const Color deepNavy = Color(0xFF134E4A);
  static const Color iceBlue = Color(0xFFF0FDFA);
  static const Color borderSubtle = Color(0xFFCCFBF1);
  static const Color textGrey = Color(0xFF64748B);
  static const Color verifiedEmerald = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFFDCFCE7);
  static const Color amberBadge = Color(0xFFF59E0B);
  static const Color secureGreen = Color(0xFF10B981);
  static const Color secureGreenLight = Color(0xFFDCFCE7);

  // ---------------------------------------------------------------------------
  // Light Theme Palette
  // ---------------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF0FDFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightInputFill = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Dark Theme Palette
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF042F2E);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkSurfaceSubtle = Color(0xFF134E4A);
  static const Color darkInputFill = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkDivider = Color(0xFF1E293B);

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // ---------------------------------------------------------------------------
  // Dynamic Theme Helpers
  // ---------------------------------------------------------------------------
  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;
  static Color surface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color surfaceSubtle(bool isDark) =>
      isDark ? darkSurfaceSubtle : lightSurfaceSubtle;
  static Color inputFill(bool isDark) =>
      isDark ? darkInputFill : lightInputFill;
  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color textMuted(bool isDark) => isDark ? darkTextMuted : lightTextMuted;
  static Color border(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color divider(bool isDark) => isDark ? darkDivider : lightDivider;

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF115E59)],
  );

  static const LinearGradient docuSewaHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF134E4A), Color(0xFF0D9488)],
  );

  static const LinearGradient janSevaHeroGradient = docuSewaHeroGradient;

  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF042F2E), Color(0xFF0F172A)],
  );

  static const LinearGradient heroGradientLight = docuSewaHeroGradient;

  // ---------------------------------------------------------------------------
  // Utilities
  // ---------------------------------------------------------------------------
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }
}
