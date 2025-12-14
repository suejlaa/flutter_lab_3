class Meal {
  String id;
  String name;
  String thumbnail;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
}
