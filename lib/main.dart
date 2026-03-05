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
    return MaterialApp(
      title: 'Cat Tinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AppRoot(scope: scope),
    );
  }
}
