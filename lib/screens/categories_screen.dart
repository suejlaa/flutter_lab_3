import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_service.dart';
import 'meals_by_category_screen.dart';
import 'random_meal_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  MealService api = MealService();
  List<Category> categories = [];
  List<Category> filtered = [];
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  void dispose() {
    if (debounce != null) {
      debounce!.cancel();
    }
    super.dispose();
  }

  void loadCategories() async {
    categories = await api.getCategories();
    filtered = categories;
    setState(() {});
  }

  void search(String query) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(Duration(milliseconds: 400), () {
      String lower = query.toLowerCase();
      filtered = categories.where((c) => c.name.toLowerCase().contains(lower)).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => RandomMealScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, i) {
                final c = filtered[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MealsByCategoryScreen(category: c.name)),
                    );
                  },
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(3.14159),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(c.thumbnail),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
                        ],
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(12),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationX(3.14159),
                        child: Text(
                          c.name,
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
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
