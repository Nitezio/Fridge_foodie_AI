// C:\Users\DELL\StudioProjects\Test5\lib\saved_recipes_screen.dart
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail_screen.dart'; // Import the RecipeDetailScreen

class SavedRecipesScreen extends StatelessWidget {
  final List<Recipe> savedRecipes;

  SavedRecipesScreen({required this.savedRecipes});

  @override
  Widget build(BuildContext context) {
    if (savedRecipes.isEmpty) {
      return Center(
        child: Text('No saved recipes yet!', style: TextStyle(fontSize: 18.0)),
      );
    }

    return ListView.builder(
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = savedRecipes[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
