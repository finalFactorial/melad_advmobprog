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
    final seed = const Color(0xFF2EC4B6); // accent green

    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        title: 'Movie Favorites',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xFF0B0B0B),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0B0B0B),
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}
