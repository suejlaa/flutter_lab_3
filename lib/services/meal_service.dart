import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class MealService {
  String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> getCategories() async {
    var res = await http.get(Uri.parse(baseUrl + "/categories.php"));
    var data = jsonDecode(res.body);
    var list = data['categories'] as List;
    return list.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    var res = await http.get(Uri.parse(baseUrl + "/filter.php?c=" + category));
    var data = jsonDecode(res.body);
    var list = data['meals'] as List;
    return list.map((json) => Meal.fromJson(json)).toList();
  }

  Future<List<Meal>> searchMeals(String query) async {
    var res = await http.get(Uri.parse(baseUrl + "/search.php?s=" + query));
    var data = jsonDecode(res.body);
    if (data['meals'] == null) return [];
    var list = data['meals'] as List;
    return list.map((json) => Meal.fromJson(json)).toList();
  }

  Future<MealDetail> getMealDetail(String id) async {
    var res = await http.get(Uri.parse(baseUrl + "/lookup.php?i=" + id));
    var data = jsonDecode(res.body);
    return MealDetail.fromJson(data['meals'][0]);
  }

  Future<MealDetail> getRandomMeal() async {
    var res = await http.get(Uri.parse(baseUrl + "/random.php"));
    var data = jsonDecode(res.body);
    return MealDetail.fromJson(data['meals'][0]);
  }
}
