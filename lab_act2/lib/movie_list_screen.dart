import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_movies_screen.dart';
import 'movie_provider.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  static const movies = <Movie>[
    Movie(title: 'The Shawshank Redemption', genre: 'Drama', year: '1994'),
    Movie(title: 'Inception', genre: 'Sci-Fi', year: '2010'),
    Movie(title: 'The Dark Knight', genre: 'Action', year: '2008'),
    Movie(title: 'Parasite', genre: 'Thriller', year: '2019'),
    Movie(title: 'The Matrix', genre: 'Sci-Fi', year: '1999'),
    Movie(title: 'La La Land', genre: 'Musical', year: '2016'),
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
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isFavorite = favoritesProvider.isFavorite(movie);

          return ListTile(
            title: Text(movie.title),
            subtitle: Text('${movie.genre} • ${movie.year}'),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(movie);
              },
            ),
          );
        },
      ),
    );
  }
}
