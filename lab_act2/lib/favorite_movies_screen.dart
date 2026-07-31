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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade600),
                  const SizedBox(height: 12),
                  Text('No favorite movies yet.', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, color: Colors.white)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final movie = favorites[index];

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
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      favoritesProvider.removeFavorite(movie);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
