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
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _themeService = ThemeService();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeService>.value(
      value: _themeService,
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'Switch Theme',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeService.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}
