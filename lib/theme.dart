import 'package:flutter/material.dart';

class AppTheme {
  // Warna Utama ITS (Biru Tua)
  static const Color primaryColor = Color(0xFF1E3A8A);
  
  // Warna Aksen/Secondary
  static const Color secondaryColor = Color(0xFF00B0FF);
  
  // Warna Background Chat
  static const Color chatBackgroundColor = Color(0xFFF5F6F8);
  
  // Warna Bubble Chat
  static const Color userBubbleColor = primaryColor;
  static const Color botBubbleColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}