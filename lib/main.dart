import 'package:flutter/material.dart';

import 'main_screen.dart';
import 'theme.dart';

void main() {
  runApp(const PrivacyVaultApp());
}

class PrivacyVaultApp extends StatelessWidget {
  const PrivacyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Privacy Vault',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mint,
          primary: AppColors.navy,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          shape: cardShape,
          elevation: 2,
          color: Colors.white,
        ),
      ),

      // MainScreen owns the bottom navigation, the shared receipts list,
      // and switching between the four tabs.
      home: const MainScreen(),
    );
  }
}
