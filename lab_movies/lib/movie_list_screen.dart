import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favorite_movies_screen.dart';
import 'movie_provider.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  static const movies = <Movie>[
    Movie(title: '22 Jump Street', genre: 'Comedy / Action', year: '2012'),
    Movie(title: 'White Chicks', genre: 'Comedy / Crime', year: '2004'),
    Movie(title: 'The Hunger Games', genre: 'Action / Adventure', year: '2012'),
    Movie(title: 'The Maze Runner', genre: 'Sci-Fi / Action', year: '2014'),
    Movie(title: 'How to Lose a Guy in 10 Days', genre: 'Romance / Comedy', year: '2003'),
    Movie(title: 'As Above, So Below', genre: 'Horror / Adventure', year: '2014'),
  ];

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'View favorites',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoriteMoviesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isFavorite = favoritesProvider.isFavorite(movie);

          return Card(
            color: const Color(0xFF111111),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(movie.title.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              title: Text(movie.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              subtitle: Text('${movie.genre} • ${movie.year}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
              trailing: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Theme.of(context).colorScheme.secondary : Colors.grey[400]),
                onPressed: () => Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(movie),
              ),
            ),
          );
        },
      ),
    );
  }
}
