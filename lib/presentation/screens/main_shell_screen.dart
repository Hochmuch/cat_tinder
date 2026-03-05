import 'package:flutter/material.dart';

import '../../core/di/app_scope.dart';
import 'breeds_list_screen.dart';
import 'random_cat_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    required this.scope,
    required this.onLogout,
  });

  final AppScope scope;
  final Future<void> Function() onLogout;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Tinder'),
        actions: [
          IconButton(
            tooltip: 'Выйти',
            onPressed: () async => widget.onLogout(),
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.pets), text: 'Котики'),
            Tab(icon: Icon(Icons.list_alt), text: 'Список пород'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RandomCatScreen(controller: widget.scope.createRandomCatController()),
          BreedsListScreen(controller: widget.scope.createBreedsController()),
        ],
      ),
    );
  }
}
