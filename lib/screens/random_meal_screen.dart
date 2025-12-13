import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import '../services/meal_service.dart';

class RandomMealScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RandomMealScreenState();
  }
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  MealService api = MealService();
  MealDetail? meal;

  @override
  void initState() {
    super.initState();
    loadRandom();
  }

  void loadRandom() async {
    meal = await api.getRandomMeal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Random Meal")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Random Meal")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(meal!.thumbnail),
            SizedBox(height: 20),
            Text(
              meal!.name,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Ingredients:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: meal!.ingredients.entries.map((entry) {
                return Text("${entry.key}: ${entry.value}", style: TextStyle(fontSize: 16));
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Instructions:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(meal!.instructions, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
