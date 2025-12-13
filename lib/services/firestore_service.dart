import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a favorite meal
  Future<void> addFavoriteMeal(String userId, Meal meal) async {
    await _db.collection('favorites').doc(userId).collection('meals').doc(meal.id).set({
      'id': meal.id,
      'name': meal.name,
      'thumbnail': meal.thumbnail,
      'isFavorite': true,
    });
  }

  // Remove a favorite meal
  Future<void> removeFavoriteMeal(String userId, Meal meal) async {
    await _db.collection('favorites').doc(userId).collection('meals').doc(meal.id).delete();
  }

  // Fetch all favorite meals
  Future<List<Meal>> getFavoriteMeals(String userId) async {
    QuerySnapshot snapshot = await _db.collection('favorites').doc(userId).collection('meals').get();
    return snapshot.docs.map((doc) {
      return Meal(
        id: doc['id'],
        name: doc['name'],
        thumbnail: doc['thumbnail'],
        isFavorite: doc['isFavorite'],
      );
    }).toList();
  }
}
