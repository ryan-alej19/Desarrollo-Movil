import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switch_theme/services/theme_service.dart';
import 'package:switch_theme/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Switch Theme',
            theme: themeService.getTheme(),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeService.selectedColor,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MyHomePage(
              onToggleDarkMode: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
              isDarkMode: _isDarkMode,
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final VoidCallback onToggleDarkMode;
  final bool isDarkMode;

  const MyHomePage({
    super.key,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return HomeView(
      onToggleDarkMode: onToggleDarkMode,
      isDarkMode: isDarkMode,
    );
  }
}
