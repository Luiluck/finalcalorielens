import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodRecipe extends StatefulWidget {
  final String foodName;
  final String foodImage;
  final String recipeDetails;

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
    ],
    'Pork Sinigang': [
      "1 lb pork belly or ribs",
      "1 onion, quartered",
      "2 tomatoes, quartered",
      "1 radish, sliced",
      "1 eggplant, sliced",
      "1 pack of tamarind paste or fresh tamarind",
      "1 bundle of kangkong (water spinach)",
      "2 long green beans, sliced",
      "1-2 chili peppers (optional)",
      "Salt and fish sauce to taste",
      "Water (about 6 cups)"
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
    ],
    'Pork Sinigang': [
      "1. In a large pot, boil the pork belly or ribs with water and onions.",
      "2. Add tomatoes and cook until soft.",
      "3. Add the tamarind paste or fresh tamarind and stir.",
      "4. Add radish, eggplant, green beans, and chili peppers.",
      "5. Let it simmer for about 30 minutes or until the pork is tender.",
      "6. Add the kangkong (water spinach) and cook for another 5 minutes.",
      "7. Season with salt and fish sauce to taste.",
      "8. Serve hot with steamed rice."
    ]
  };

  @override
  Widget build(BuildContext context) {
    List<String> currentIngredients = ingredients[widget.foodName] ?? [];
    List<String> currentInstructions = instructions[widget.foodName] ?? [];

    return Scaffold(
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
                // Add a border and shadow around the food image
                Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    border: Border.all(
                      color: Colors.blueGrey.shade300, // Border color
                      width: 4.0, // Border thickness
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 8.0, // Shadow blur
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(widget.foodImage),
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
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Recipe description/details
                      Text(
                        widget.recipeDetails,
                        style: GoogleFonts.roboto(
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
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Display ingredients dynamically
                      for (var ingredient in currentIngredients)
                        Text(
                          "- $ingredient",
                          style: GoogleFonts.roboto(
                            fontSize: 16.0,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      SizedBox(height: 20.0),
                      Text(
                        "Instructions",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Display instructions dynamically
                      for (var instruction in currentInstructions)
                        Text(
                          instruction,
                          style: GoogleFonts.roboto(
                            fontSize: 16.0,
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Custom back button at the bottom-right
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // go back
              },
              backgroundColor: Colors.transparent,
              elevation: 2, // remove elevation for a flat look
              child: Icon(
                Icons.arrow_back,
                color: Colors.white.withOpacity(0.7), //for thickness color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
