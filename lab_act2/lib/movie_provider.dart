import 'package:flutter/foundation.dart';

class Movie {
  final String title;
  final String genre;
  final String year;

  const Movie({
    required this.title,
    required this.genre,
    required this.year,
  });
}

class FavoritesProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Movie movie) {
    return _favorites.contains(movie);
  }

  void addFavorite(Movie movie) {
    if (!_favorites.contains(movie)) {
      _favorites.add(movie);
      notifyListeners();
    }
  }

  void removeFavorite(Movie movie) {
    if (_favorites.remove(movie)) {
      notifyListeners();
    }
  }

  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      removeFavorite(movie);
    } else {
      addFavorite(movie);
    }
  }
}
