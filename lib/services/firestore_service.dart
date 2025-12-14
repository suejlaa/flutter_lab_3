import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a meal to the user's favorites
  Future<void> addFavoriteMeal(String userId, Meal meal) async {
    await _db.collection('favorites').doc(userId).collection('meals').doc(meal.id).set({
      'mealId': meal.id,
      'name': meal.name,
      'thumbnail': meal.thumbnail,
    });
  }

  // Remove a meal from the user's favorites
  Future<void> removeFavoriteMeal(String userId, Meal meal) async {
    await _db.collection('favorites').doc(userId).collection('meals').doc(meal.id).delete();
  }

  // Get favorite meals for the user (optional, if you want to load favorites)
  Future<List<Meal>> getFavoriteMeals(String userId) async {
    final snapshot = await _db.collection('favorites').doc(userId).collection('meals').get();
    return snapshot.docs
        .map((doc) => Meal(
      id: doc.id,
      name: doc['name'],
      thumbnail: doc['thumbnail'],
      isFavorite: true, // Since it's a favorite, we mark it as true
    ))
        .toList();
  }
}
