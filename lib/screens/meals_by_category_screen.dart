import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../services/firestore_service.dart'; // New service for Firebase

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  MealsByCategoryScreen({required this.category});

  @override
  _MealsByCategoryScreenState createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  MealService api = MealService();
  FirestoreService firestoreService = FirestoreService();  // Firestore service instance
  List<Meal> meals = [];
  List<Meal> filtered = [];
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  @override
  void dispose() {
    if (debounce != null) {
      debounce!.cancel();
    }
    super.dispose();
  }

  void loadMeals() async {
    meals = await api.getMealsByCategory(widget.category);
    filtered = meals;
    setState(() {});
  }

  void search(String query) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        filtered = meals;
      } else {
        filtered = await api.searchMeals(query);
      }
      setState(() {});
    });
  }

  // Function to handle adding/removing from favorites
  void toggleFavorite(Meal meal) async {
    // Check if the meal is already marked as a favorite
    if (meal.isFavorite) {
      // Remove from Firebase favorites
      await firestoreService.removeFavoriteMeal('userId', meal);  // Replace 'userId' with actual user ID
    } else {
      // Add to Firebase favorites
      await firestoreService.addFavoriteMeal('userId', meal);  // Replace 'userId' with actual user ID
    }

    // Toggle the favorite status
    setState(() {
      meal.isFavorite = !meal.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search meals...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, i) {
                final meal = filtered[i];
                return GestureDetector(
                  onTap: () {
                    // Handle navigation to meal details screen
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                meal.thumbnail,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon: Icon(
                                  meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: meal.isFavorite ? Colors.red : Colors.white,
                                ),
                                onPressed: () => toggleFavorite(meal),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 28,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.center,
                          child: Text(
                            meal.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
