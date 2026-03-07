import 'package:flutter/material.dart';

import 'core/di/app_scope.dart';
import 'presentation/screens/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final scope = await AppScope.create();
  runApp(MyApp(scope: scope));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.scope});

  final AppScope scope;

  @override
  Widget build(BuildContext context) {
    final darkColorScheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF0F0F12),
          surfaceContainerHighest: const Color(0xFF1A1A22),
          primary: const Color(0xFF9F7AEA),
          secondary: const Color(0xFFC4B5FD),
        );

    return MaterialApp(
      title: 'Cat Tinder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          elevation: 0,
        ),
      ),
      home: AppRoot(scope: scope),
    );
  }
}
