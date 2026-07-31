import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movie_provider.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FavoritesProvider>(
          builder: (context, favs, child) => Text('Favorite Movies (${favs.favorites.length})'),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favs, child) {
              if (favs.favorites.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Clear all favorites',
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear favorites?'),
                      content: const Text('Remove all favorite movies? This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear')),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    favs.clearFavorites();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies yet.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final movie = favorites[index];

              return ListTile(
                title: Text(movie.title),
                subtitle: Text('${movie.genre} • ${movie.year}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    favoritesProvider.removeFavorite(movie);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
