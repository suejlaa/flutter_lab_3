import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../services/meal_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String id;

  MealDetailScreen({required this.id});

  @override
  State<StatefulWidget> createState() {
    return _MealDetailScreenState();
  }
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  MealService api = MealService();
  MealDetail? meal;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  void loadMeal() async {
    meal = await api.getMealDetail(widget.id);
    setState(() {});
  }

  Future<void> openYoutube(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open YouTube link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(meal!.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(meal!.thumbnail),
            ),
            SizedBox(height: 15),
            Text(
              meal!.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Ingredients:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: meal!.ingredients.entries.map((entry) {
                return Text(
                  "• ${entry.key}: ${entry.value}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text(
              "Instructions:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              meal!.instructions,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            if (meal!.youtube.isNotEmpty)
              ElevatedButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text("Watch on YouTube"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  openYoutube(meal!.youtube);
                },
              ),
          ],
        ),
      ),
    );
  }
}
