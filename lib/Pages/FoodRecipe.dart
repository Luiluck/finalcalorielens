import 'package:flutter/material.dart';

class FoodRecipe extends StatefulWidget {
  // Define the required parameters
  final String foodName;
  final String foodImage;
  final String recipeDetails;

  // Constructor to accept parameters
  const FoodRecipe({
    Key? key,
    required this.foodName,
    required this.foodImage,
    required this.recipeDetails,
  }) : super(key: key);

  @override
  _FoodRecipeState createState() => _FoodRecipeState();
}

class _FoodRecipeState extends State<FoodRecipe> {
  // Sample ingredients and instructions for the recipes
  final Map<String, List<String>> ingredients = {
    'Kaldereta': [
      "1 lb of beef",
      "2 cups of water",
      "2 carrots, chopped",
      "1 onion, chopped",
      "2 tbsp soy sauce",
      "Salt and pepper to taste"
    ],
    'Bicol Express': [
      "1 lb pork belly, sliced",
      "1 cup coconut milk",
      "2 tbsp shrimp paste",
      "5-6 Thai bird’s eye chilies",
      "1 onion, chopped",
      "Salt and pepper to taste"
    ],
    'Pork Adobo': [
      "1 lb pork, cut into chunks",
      "1/2 cup soy sauce",
      "1/2 cup vinegar",
      "6 garlic cloves, crushed",
      "2 bay leaves",
      "1 tsp black peppercorns",
      "1 tbsp brown sugar",
      "Salt to taste"
    ]
  };

  final Map<String, List<String>> instructions = {
    'Kaldereta': [
      "1. Brown the beef in a pot.",
      "2. Add water, carrots, onions, and soy sauce.",
      "3. Let it simmer for 45 minutes.",
      "4. Add salt and pepper to taste.",
      "5. Serve hot with rice."
    ],
    'Bicol Express': [
      "1. Sauté the pork belly and onions until golden brown.",
      "2. Add the shrimp paste and cook for a few minutes.",
      "3. Pour in the coconut milk and bring it to a simmer.",
      "4. Add the chilies and let it cook until thick.",
      "5. Season with salt and pepper.",
      "6. Serve with steamed rice."
    ],
    'Pork Adobo': [
      "1. In a large pot, combine soy sauce, vinegar, garlic, bay leaves, and peppercorns.",
      "2. Add pork and marinate for 30 minutes.",
      "3. Cook the pork mixture over medium heat until the pork is tender.",
      "4. Add brown sugar and cook until the sauce reduces.",
      "5. Season with salt to taste and serve with rice."
    ]
  };

  @override
  Widget build(BuildContext context) {
    // Get the current recipe's ingredients and instructions
    List<String> currentIngredients = ingredients[widget.foodName] ?? [];
    List<String> currentInstructions = instructions[widget.foodName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName), // Display food name in the AppBar
        backgroundColor: const Color(0xffA8BBA2), // Mint color background for the AppBar
        elevation: 0,
        automaticallyImplyLeading: true, // Keeps the default back arrow button
      ),
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff7f7f7), Color(0xffd6e4d9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Food recipe content
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Display food image at the top
                Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.foodImage), // Display food image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Display food details (name and description)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Food name
                      Text(
                        widget.foodName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Recipe description/details
                      Text(
                        widget.recipeDetails,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                // Ingredients section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Display ingredients dynamically
                      for (var ingredient in currentIngredients)
                        Text(
                          "- $ingredient",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey.shade700),
                        ),
                      SizedBox(height: 20.0),
                      Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Display instructions dynamically
                      for (var instruction in currentInstructions)
                        Text(
                          instruction,
                          style: TextStyle(fontSize: 16.0, color: Colors.grey.shade700),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
