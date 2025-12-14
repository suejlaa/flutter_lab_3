import 'meal.dart';

class FavoriteMeal {
  String id;
  String name;
  String thumbnail;

  FavoriteMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  Meal toMeal() {
    return Meal(id: id, name: name, thumbnail: thumbnail);
  }

  
  factory FavoriteMeal.fromMeal(Meal meal) {
    return FavoriteMeal(
      id: meal.id,
      name: meal.name,
      thumbnail: meal.thumbnail,
    );
  }
}
