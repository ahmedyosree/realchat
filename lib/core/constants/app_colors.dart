import 'package:flutter/material.dart';

class AppColors {
  // ─── Scaffold & Backgrounds ───
  /// Overall screen background (light grey)
  static const Color scaffoldBg       = Color(0xFFF2F2F7);
  /// Chat list background (slightly darker)
  static const Color chatListBg       = Color(0xFFEDEDED);

  // ─── Chat Bubbles ───
  /// My message bubble
  static const Color bubbleMe         = Color(0xFF66BB6A); // Green 400
  /// Other user message bubble
  static const Color bubbleOther      = Color(0xFFF1F0F0); // Grey 200
  /// System/notice bubble
  static const Color bubbleSystem     = Color(0xFFFFF9C4); // Yellow 100

  // ─── Text Colors ───
  /// Primary text (in dark bubbles)
  static const Color textPrimary      = Color(0xFF212121); // Grey 900
  /// Secondary text (timestamps, captions)
  static const Color textSecondary    = Color(0xFF757575); // Grey 600
  /// Inverse text (on colored bubbles)
  static const Color textOnPrimary    = Colors.white;

  // ─── Accent & Actions ───
  /// Send button background / highlights
  static const Color accent           = Color(0xFF43A047); // Green 600
  /// Send icon / tappable icons
  static const Color icon             = Color(0xFF1B5E20); // Green 900
  /// Disabled button/icon
  static const Color iconDisabled     = Color(0xFFBDBDBD); // Grey 400

  // ─── Input Field ───
  /// Input bar background
  static const Color inputBg          = Colors.white;
  /// Input hint text
  static const Color inputHint        = Color(0xFF9E9E9E); // Grey 500
  /// Input text color
  static const Color inputText        = Color(0xFF212121); // Grey 900
  /// Input border (when focused)
  static const Color inputBorder      = Color(0xFF66BB6A); // Green 400

  // ─── AppBar & Status ───
  /// AppBar background gradient start
  static const Color appBarGradient1  = Color(0xFF667EEA);
  /// AppBar background gradient end
  static const Color appBarGradient2  = Color(0xFF64B6FF);
  /// AppBar title text
  static const Color appBarText       = Colors.white;
  /// Online status dot
  static const Color statusOnline     = Color(0xFF4CAF50); // Green 500
  /// Offline status dot
  static const Color statusOffline    = Color(0xFFBDBDBD); // Grey 400

  /// Google “G” icon (if you want a unique shade)
  static const Color googleIcon = Color(0xFF1A73E8);
  // ─── Dividers & Shadows ───
  /// Light divider between messages or sections
  static const Color divider          = Color(0xFFEEEEEE); // Grey 200
  /// Shadow color for input bar elevation
  static final Color shadow           = Colors.black.withOpacity(0.05);
}
