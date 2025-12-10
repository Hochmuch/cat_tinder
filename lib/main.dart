import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _counter = 0;
  Future<List<dynamic>>? catDataFuture;

  @override
  void initState() {
    super.initState();
    catDataFuture = fetchCatData();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void likeCat() {
    setState(() {
      catDataFuture = fetchCatData();
    });
    _incrementCounter();
  }

  void dislikeCat() {
    setState(() {
      catDataFuture = fetchCatData();
    });
  }

  Future<List<dynamic>> fetchCatData() async {
    final url = Uri.parse('https://api.thecatapi.com/v1/images/search');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Данные не были получены(");
    }

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: catDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final data = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        likeCat();
                      } else if (direction == DismissDirection.endToStart) {
                        dislikeCat();
                      }
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data[0]['url'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '$_counter',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Bottom-centered round buttons overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'left-btn',
                    onPressed: () {
                      dislikeCat();
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    heroTag: 'right-btn',
                    onPressed: () {
                      likeCat();
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.favorite),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
