import 'package:flutter/material.dart';
import 'market_data_screen.dart';
import '../utils/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        elevation: 0,
      ),
      body: const MarketDataScreen(),
    );
  }
}
