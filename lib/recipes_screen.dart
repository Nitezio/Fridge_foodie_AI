// C:\Users\DELL\StudioProjects\Test5\lib\recipes_screen.dart
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail_screen.dart';
import 'generate_recipe_screen.dart';

class RecipesScreen extends StatefulWidget {
  final Function(Recipe) onRecipeSaved;
  final Function(Recipe) onRecipeUnsaved;

  RecipesScreen({required this.onRecipeSaved, required this.onRecipeUnsaved});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final List<Recipe> _allRecipes = [
    Recipe(
      id: '1',
      title: 'Spaghetti Bolognese',
      description: 'Classic Italian pasta dish with a rich meat sauce.',
      cuisine: 'Italian',
      servings: 4,
      totalTime: '45 mins',
      ingredients: ['Spaghetti', 'Ground beef', 'Tomato sauce', 'Onion', 'Garlic', 'Herbs', 'Olive Oil'],
      mealType: 'Dinner',
      instructions: [
        '1. Cook spaghetti according to package directions.',
        '2. In a large pan, brown ground beef with chopped onion and garlic.',
        '3. Stir in tomato sauce and herbs. Simmer for 20 minutes.',
        '4. Serve the sauce over the cooked spaghetti.',
      ],
      calories: 450,
      protein: 25,
      fat: 20,
      carbs: 40,
    ),
    Recipe(
      id: '2',
      title: 'Chicken Stir-Fry',
      description: 'Quick and easy stir-fried chicken with vegetables.',
      cuisine: 'Asian',
      servings: 2,
      totalTime: '30 mins',
      ingredients: ['Chicken breast', 'Broccoli', 'Carrots', 'Soy sauce', 'Ginger', 'Garlic', 'Bell peppers'],
      mealType: 'Lunch',
      instructions: [
        '1. Cut chicken breast into bite-sized pieces.',
        '2. Stir-fry chicken in a hot pan with oil until cooked through.',
        '3. Add broccoli, carrots, and bell peppers. Stir-fry for 5 minutes.',
        '4. Stir in soy sauce, ginger, and garlic. Cook for another 2 minutes.',
        '5. Serve hot.',
      ],
      calories: 350,
      protein: 30,
      fat: 15,
      carbs: 20,
    ),
    Recipe(
      id: '3',
      title: 'Chocolate Cake',
      description: 'Delicious and moist chocolate cake.',
      cuisine: 'Dessert',
      servings: 8,
      totalTime: '1 hour',
      ingredients: ['Flour', 'Sugar', 'Cocoa powder', 'Eggs', 'Milk', 'Oil', 'Vanilla extract'],
      mealType: 'Dessert',
      instructions: [
        '1. Preheat oven to 350°F (175°C). Grease and flour a cake pan.',
        '2. In a large bowl, whisk together flour, sugar, and cocoa powder.',
        '3. Add eggs, milk, oil, and vanilla extract. Beat until smooth.',
        '4. Pour batter into the prepared pan and bake for 30-35 minutes.',
        '5. Let cool completely before frosting.',
      ],
      calories: 300,
      protein: 4,
      fat: 18,
      carbs: 35,
    ),
    Recipe(
      id: '4',
      title: 'Miso Soup',
      description: 'Traditional Japanese soup with fermented soybean paste.',
      cuisine: 'Japanese',
      servings: 2,
      totalTime: '20 mins',
      ingredients: ['Dashi', 'Miso paste', 'Tofu', 'Seaweed', 'Green onions'],
      mealType: 'Lunch',
      instructions: [
        '1. Heat dashi in a saucepan.',
        '2. Reduce heat to low and whisk in miso paste until dissolved.',
        '3. Add tofu and seaweed.',
        '4. Garnish with chopped green onions and serve.',
      ],
      calories: 80,
      protein: 5,
      fat: 3,
      carbs: 8,
    ),
    Recipe(
      id: '5',
      title: 'Beef Tacos',
      description: 'Classic Mexican street food with seasoned beef.',
      cuisine: 'Mexican',
      servings: 3,
      totalTime: '35 mins',
      ingredients: ['Ground beef', 'Tortillas', 'Onion', 'Cilantro', 'Salsa'],
      mealType: 'Dinner',
      instructions: [
        '1. Brown ground beef in a skillet. Drain any excess fat.',
        '2. Stir in taco seasoning and a little water. Simmer until liquid is absorbed.',
        '3. Warm tortillas according to package directions.',
        '4. Fill tortillas with seasoned beef, chopped onion, and cilantro.',
        '5. Serve with salsa.',
      ],
      calories: 320,
      protein: 20,
      fat: 18,
      carbs: 25,
    ),
  ];

  String? _selectedCuisineFilter;
  String? _selectedMealTypeFilter;

  List<String> get _cuisineFilters => ['All', ..._allRecipes.map((r) => r.cuisine).toSet().toList()];
  List<String> get _mealTypeFilters => ['All', ..._allRecipes.map((r) => r.mealType).toSet().toList()];

  List<Recipe> get _filteredRecipes {
    return _allRecipes.where((recipe) {
      final cuisineMatch = _selectedCuisineFilter == null || _selectedCuisineFilter == 'All' || recipe.cuisine == _selectedCuisineFilter;
      final mealTypeMatch = _selectedMealTypeFilter == null || _selectedMealTypeFilter == 'All' || recipe.mealType == _selectedMealTypeFilter;
      return cuisineMatch && mealTypeMatch;
    }).toList();
  }

  void _toggleSave(int index) {
    setState(() {
      final recipe = _filteredRecipes[index];
      recipe.isSaved = !recipe.isSaved;
      if (recipe.isSaved) {
        widget.onRecipeSaved(recipe);
      } else {
        widget.onRecipeUnsaved(recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: _selectedCuisineFilter,
                  hint: Text('Cuisine'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCuisineFilter = newValue;
                    });
                  },
                  items: _cuisineFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: _selectedMealTypeFilter,
                  hint: Text('Meal Type'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMealTypeFilter = newValue;
                    });
                  },
                  items: _mealTypeFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _filteredRecipes[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      recipe.cuisine,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      recipe.description,
                                      style: TextStyle(color: Colors.grey[700]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 4.0,
                                  children: recipe.ingredients.take(3).map((ingredient) => Chip(
                                    label: Text(ingredient, style: TextStyle(fontSize: 12.0)),
                                  )).toList(),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              IconButton(
                                icon: Icon(
                                  recipe.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                  color: recipe.isSaved ? Colors.amber : null,
                                ),
                                onPressed: () => _toggleSave(index),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.people, size: 14.0, color: Colors.grey[600]),
                              SizedBox(width: 4.0),
                              Text('${recipe.servings} Servings', style: TextStyle(fontSize: 12.0)),
                              SizedBox(width: 8.0),
                              Icon(Icons.timer_outlined, size: 14.0, color: Colors.grey[600]),
                              SizedBox(width: 4.0),
                              Text(recipe.totalTime, style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GenerateRecipeScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Generate New Recipe',
      ),
    );
  }
}
