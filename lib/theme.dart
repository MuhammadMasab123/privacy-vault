import 'package:flutter/material.dart';

/// Shared colours for the redesign (dark navy + mint "vault" look).
/// One place for colours so every screen matches.
class AppColors {
  static const navy = Color(0xFF0B1230);
  static const navyLight = Color(0xFF1B2547);
  static const mint = Color(0xFF00C896);
  static const mintDark = Color(0xFF00A67E);
  static const mintSoft = Color(0xFFD9F7EC);
  static const background = Color(0xFFF4F6F8);
  static const textDark = Color(0xFF0B1230);
  static const danger = Color(0xFFE53935);
  static const warning = Color(0xFFFF9800);
}

/// The shared card shape used on every screen.
final cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(16),
);
