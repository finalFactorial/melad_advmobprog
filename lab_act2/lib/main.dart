import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_list_screen.dart';
import 'movie_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        title: 'Movie Favorites',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}
