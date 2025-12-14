import 'package:flutter/material.dart';
import '../models/favorite_meal.dart';
import '../services/favorite_service.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoriteService favoriteService = FavoriteService();  // Initialize FavoriteService

  @override
  Widget build(BuildContext context) {
    List<FavoriteMeal> favorites = favoriteService.getFavorites();

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: favorites.isEmpty
          ? Center(child: Text("No favorite meals yet"))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, i) {
          final meal = favorites[i];
          return ListTile(
            leading: Image.network(meal.thumbnail, width: 50, height: 50),
            title: Text(meal.name),
            onTap: () {
              // Navigate to meal detail
            },
          );
        },
      ),
    );
  }
}
