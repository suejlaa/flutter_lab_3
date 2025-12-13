class MealDetail {
  String id;
  String name;
  String instructions;
  String thumbnail;
  String youtube;
  Map<String, String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingredients = {};

    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty && ingredient != ' ') {
        ingredients[ingredient] = measure ?? '';
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
