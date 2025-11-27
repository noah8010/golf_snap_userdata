import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GolfStatsApp(),
    ),
  );
}

class GolfStatsApp extends StatelessWidget {
  const GolfStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Stats',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
