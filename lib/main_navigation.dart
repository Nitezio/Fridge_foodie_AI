// C:\Users\DELL\StudioProjects\Test5\lib\main_navigation.dart
import 'package:flutter/material.dart';
import 'fridge_inventory_screen.dart';
import 'recipes_screen.dart';
import 'saved_recipes_screen.dart';
import 'settings_screen.dart'; // You might need to create this file
import 'recipe.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Recipe> _savedRecipes = [];

  void _saveRecipe(Recipe recipe) {
    setState(() {
      if (!_savedRecipes.any((r) => r.id == recipe.id)) {
        _savedRecipes.add(recipe);
      }
    });
  }

  void _unsaveRecipe(Recipe recipe) {
    setState(() {
      _savedRecipes.removeWhere((r) => r.id == recipe.id);
    });
  }

  late List<Widget> _widgetOptions; // Initialize in initState

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      FridgeInventoryScreen(),
      RecipesScreen(onRecipeSaved: _saveRecipe, onRecipeUnsaved: _unsaveRecipe),
      SavedRecipesScreen(savedRecipes: _savedRecipes),
      SettingsScreen(), // You might need to create this file
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Fridge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}