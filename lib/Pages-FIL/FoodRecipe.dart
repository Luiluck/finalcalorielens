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
      "1 Libra ng baka",
      "2 Tasa ng tubig",
      "2 Karots na tinadtad",
      "1 Tinadtad ng Sibuyas",
      "2 Tablespoon ng toyo",
      "Asin at paminta"
    ],
    'Bikol Express': [
      "1 libra ng hiniwang tiyan ng baboy",
      "1 Tasa Gata ng niyog",
      "2 tbsp ng shrimp paste",
      "5-6 Thai bird’s eye chilies",
      "1 tinadtad ng sibuyas, chopped",
      "Salt and pepper to taste"
    ],
    'Adobong Baboy': [
      "1 lb pork, cut into chunks",
      "1/2 tasa ng toyo",
      "1/2 tasa ng suka",
      "6 Dinurog na garlic cloves",
      "2 Dahon ng Laurel",
      "1 tsp Buong paminta",
      "1 tbsp Pulang asukal",
      "Asin"
    ],
    'Sinigang na Baboy': [
      "1 Libra ng tiyan ng baboy o tadyang",
      "1 sibuyas, kubo",
      "2 Kamatis, kubo",
      "1 Labanos na hiwa-hiwa",
      "1 Talong na Hiwa-hiwa",
      "1 Pack na sampalok paste o sariwang sampalok",
      "1 Tali ng kangkong",
      "2 Hiniwa na sitaw",
      "1-2 Siling labuyo (opsyonal)",
      "Asin at patis",
      "Tubig (6 tasa)"
    ]
  };

  final Map<String, List<String>> instructions = {
    'Kaldereta': [
      "1. Igisa ang karne ng baka sa kaldero.",
      "2. Dagdagan ng tubig, karots, Sibuyas at toyo.",
      "3. Hayaang itong kumulo sa loob ng 45 minuto.",
      "4. Pudporan ng asin at paminta.",
      "5. Ihain habang mainit sa kanin."
    ],
    'Bikol Express': [
      "1. Igisa ang pork belly at sibuyas hanggang maging ginintuang kayumanggi.",
      "2. Idagdag ang shrimp paste at lutuin ito ng ilan minuto.",
      "3. idagdag ang gata at hayaang itong kumulo.",
      "4. dagdagan ito ng sili at hayaang ito maluto hanggang lumagkit ang sabaw.",
      "5. Pudporan ng asin at paminta .",
      "6. Ihain kasama ng steamed rice."
    ],
    'Adobong Baboy': [
      "1. Sa isang malaking palayok, pagsamahin ang toyo, suka, bawang, dahon ng bay, at paminta.",
      "2. Idagdag ang baboy at imarinate ng 30 minuto.",
      "3. Lutuin ang timpla ng baboy sa katamtamang init hanggang sa lumambot ang baboy.",
      "4. Magdagdag ng brown sugar at lutuin hanggang sa mabawasan ang sauce.",
      "5. Timplahan ng asin ayon sa panlasa at ihain kasama ng kanin.",
    ],
    'Sinigang na Baboy': [
      "1. Sa isang malaking kaldero, pakuluan ang pork belly o ribs na may tubig at sibuyas.",
      "2. Magdagdag ng mga kamatis at lutuin hanggang malambot.",
      "3. Idagdag ang tamarind paste o sariwang sampalok at haluin.",
      "4. Magdagdag ng labanos, talong, green beans, at sili.",
      "5. Hayaang kumulo ng mga 30 minuto o hanggang sa lumambot ang baboy.",
      "6. Idagdag ang kangkong at lutuin ng isa pang 5 minuto.",
      "7. Timplahan ng asin at patis ayon sa panlasa.",
      "8. Ihain nang mainit kasama ng steamed rice."
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
                        "mga tagubilin",
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