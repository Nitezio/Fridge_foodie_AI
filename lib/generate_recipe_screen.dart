import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'fridge_item.dart';
import 'fridge_inventory_screen.dart';
import 'dart:convert';
import 'recipe.dart';
import 'recipe_detail_screen.dart';

class GenerateRecipeScreen extends StatefulWidget {
  @override
  _GenerateRecipeScreenState createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  String? _selectedCuisine;
  String? _selectedMealType;
  int _servings = 2;
  bool _isVegan = false;
  bool _isVegetarian = false;
  bool _isGlutenFree = false;
  bool _isLoading = false;
  String? _generatedRecipeText;

  final List<String> _cuisineOptions = ['Italian', 'Asian', 'Mexican', 'Indian', 'American', 'Other'];
  final List<String> _mealTypeOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'];

  Future<List<String>> _getFridgeIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList('fridgeItems') ?? [];
    return itemsJson.map((jsonString) {
      try {
        final item = FridgeItem.fromJson(jsonDecode(jsonString));
        return '${item.name} (${item.quantity ?? 'some'} ${item.unit ?? ''})';
      } catch (e) {
        print('Error decoding fridge item: $e');
        return ''; // Return an empty string or handle the error as needed
      }
    }).where((item) => item.isNotEmpty).toList();
  }

  Future<void> _generateRecipe() async {
    if (_selectedCuisine == null || _selectedMealType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select Cuisine and Meal Type.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedRecipeText = null;
    });

    final apiKey = "AIzaSyCiivzAON1_evdchLTtAG9xDdxwzULw-Ks"; // Replace with your actual API key
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    final fridgeIngredients = await _getFridgeIngredients();

    String prompt = '''Generate a cost-saving and healthy recipe for $_servings servings, with the following preferences:
    Cuisine: $_selectedCuisine
    Meal Type: $_selectedMealType
    Dietary Restrictions:
      Vegan: ${_isVegan ? 'Yes' : 'No'}
      Vegetarian: ${_isVegetarian ? 'Yes' : 'No'}
      Gluten-Free: ${_isGlutenFree ? 'Yes' : 'No'}

    Prioritize using the following ingredients currently in the fridge:
    ${fridgeIngredients.isNotEmpty ? fridgeIngredients.join(', ') : 'No specific ingredients in fridge.'}

    You may include a small list of additional basic ingredients commonly found in households (e.g., salt, pepper, cooking oil) if needed, but minimize the need for other new ingredients.

    The recipe should include:
    - A detailed list of ingredients with quantities.
    - Clear and step-by-step instructions.

    Format the output clearly with headings for "Ingredients" and "Instructions".''';

    try {
      final response = await model.generateContent(
        [Content('user', [TextPart(prompt)])],
      );
      setState(() {
        _generatedRecipeText = response.text;
        _isLoading = false;
      });
    } catch (e) {
      print('Gemini API Error (Silent Fallback): $e'); // Log the error
      setState(() {
        _generatedRecipeText = _getDefaultRecipe(); // Set default recipe on error
        _isLoading = false;
      });
      // No SnackBar to inform the user of the fallback
    }
  }

  String _getDefaultRecipe() {
    return '''
**Default Recipe: Simple Tomato Pasta**

**Ingredients:**
- 200g pasta (e.g., spaghetti, penne)
- 400g canned chopped tomatoes
- 2 cloves garlic, minced
- 2 tablespoons olive oil
- Salt and pepper to taste
- Fresh basil leaves, for garnish (optional)

**Instructions:**
1. Cook the pasta according to the package directions until al dente. Drain and set aside.
2. While the pasta is cooking, heat the olive oil in a saucepan over medium heat.
3. Add the minced garlic and cook for about 1 minute until fragrant, being careful not to burn it.
4. Pour in the canned chopped tomatoes. Season with salt and pepper to taste.
5. Bring the tomato sauce to a simmer and cook for 5-10 minutes, stirring occasionally, to allow the flavors to meld.
6. Add the cooked pasta to the saucepan with the tomato sauce. Toss to coat evenly.
7. Serve immediately, garnished with fresh basil leaves if desired.
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Recipe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Cuisine'),
              value: _selectedCuisine,
              items: _cuisineOptions.map((cuisine) => DropdownMenuItem(value: cuisine, child: Text(cuisine))).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCuisine = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Meal Type'),
              value: _selectedMealType,
              items: _mealTypeOptions.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Servings: ${_servings}', style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_servings > 1) _servings--;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _servings++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text('Vegan'),
              value: _isVegan,
              onChanged: (value) {
                setState(() {
                  _isVegan = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Vegetarian'),
              value: _isVegetarian,
              onChanged: (value) {
                setState(() {
                  _isVegetarian = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Gluten-Free'),
              value: _isGlutenFree,
              onChanged: (value) {
                setState(() {
                  _isGlutenFree = value!;
                });
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateRecipe,
              child: _isLoading ? CircularProgressIndicator() : Text('Generate Recipe'),
            ),
            if (_generatedRecipeText != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Generated Recipe Output:\n$_generatedRecipeText'),
              ),
          ],
        ),
      ),
    );
  }
}