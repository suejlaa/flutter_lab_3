import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/meal.dart';

class FavoriteMealsScreen extends StatefulWidget {
  final String userId;

  FavoriteMealsScreen({required this.userId});

  @override
  _FavoriteMealsScreenState createState() => _FavoriteMealsScreenState();
}

class _FavoriteMealsScreenState extends State<FavoriteMealsScreen> {
  List<Meal> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMeals();
  }

  _loadFavoriteMeals() async {
    FirestoreService firestoreService = FirestoreService();
    favoriteMeals = await firestoreService.getFavoriteMeals(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Meals")),
      body: ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = favoriteMeals[index];
          return ListTile(
            title: Text(meal.name),
            leading: Image.network(meal.thumbnail),
          );
        },
      ),
    );
  }
}
