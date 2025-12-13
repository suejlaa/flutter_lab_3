class Meal {
  String id;
  String name;
  String thumbnail;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

