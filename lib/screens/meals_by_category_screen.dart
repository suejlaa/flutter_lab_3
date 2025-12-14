import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../services/favorite_service.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  MealsByCategoryScreen({required this.category});

  @override
  State<StatefulWidget> createState() {
    return _MealsByCategoryScreenState();
  }
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  MealService api = MealService();
  FavoriteService favoriteService = FavoriteService();  // Initialize FavoriteService
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
                final m = filtered[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MealDetailScreen(id: m.id)),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            m.thumbnail,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 28,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.center,
                          child: Text(
                            m.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            favoriteService.isFavorite(m.id) ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favoriteService.toggleFavorite(m);
                            });
                          },
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
