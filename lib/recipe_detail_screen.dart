// C:\Users\DELL\StudioProjects\Test5\lib\recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _currentServings = 1;

  @override
  void initState() {
    super.initState();
    _currentServings = widget.recipe.servings;
  }

  Widget _buildNutritionalInfo(String label, double? value, String unit) {
    if (value != null) {
      final adjustedValue = value / widget.recipe.servings * _currentServings;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text('$label: ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            Text('${adjustedValue.toStringAsFixed(0)} $unit', style: TextStyle(fontSize: 16.0)),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  List<String> get _adjustedIngredients {
    final originalServings = widget.recipe.servings;
    if (originalServings == 0 || _currentServings == originalServings) {
      return widget.recipe.ingredients;
    } else {
      double factor = _currentServings / originalServings;
      return widget.recipe.ingredients.map((ingredient) {
        List<String> parts = ingredient.split(' ');
        if (parts.isNotEmpty) {
          try {
            double? quantity = double.tryParse(parts[0]);
            if (quantity != null) {
              parts[0] = (quantity * factor).toStringAsFixed(2);
            }
          } catch (e) {
            // Ignore if the first part is not a number
          }
        }
        return parts.join(' ');
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              widget.recipe.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '${widget.recipe.cuisine} - ${widget.recipe.mealType}',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.grey[600]),
                    SizedBox(width: 4.0),
                    Text('${_currentServings} Servings', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_currentServings > 1) {
                            _currentServings--;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _currentServings++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _adjustedIngredients.map((ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('- $ingredient', style: TextStyle(fontSize: 16.0)),
              )).toList(),
            ),
            if (widget.recipe.instructions != null && widget.recipe.instructions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.recipe.instructions!.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        String instruction = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('$index. $instruction', style: TextStyle(fontSize: 16.0)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutritional Information (per serving)',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  _buildNutritionalInfo('Calories', widget.recipe.calories, 'kcal'),
                  _buildNutritionalInfo('Protein', widget.recipe.protein, 'g'),
                  _buildNutritionalInfo('Fat', widget.recipe.fat, 'g'),
                  _buildNutritionalInfo('Carbs', widget.recipe.carbs, 'g'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

