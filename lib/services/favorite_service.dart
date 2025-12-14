import 'package:meal_app/models/favorite_meal.dart';

import '../models/meal.dart' show Meal;

class FavoriteService {
  List<FavoriteMeal> _favorites = [];

  List<FavoriteMeal> getFavorites() {
    return _favorites;
  }

  bool isFavorite(String id) {
    return _favorites.any((meal) => meal.id == id);
  }

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal.id)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(FavoriteMeal.fromMeal(meal));
    }
  }
}
