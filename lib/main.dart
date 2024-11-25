import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/ThemeProviders.dart';
import 'View/HomeScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'News App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode, // Use ThemeMode from ThemeProvider
      home: const HomeScreen(),
    );
  }
}