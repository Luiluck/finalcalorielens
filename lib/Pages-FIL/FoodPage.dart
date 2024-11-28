import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'FoodRecipe.dart'; // Import the FoodRecipePage

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context); // Swipe right to go back
        }
      },
      child: Scaffold(
        body: SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFCE4EC), // Pink tone
                  Color(0xFFE1F5FE), // Light blue tone
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        // Welcome Container in place of the search bar
                        Container(
                          padding: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 10.0),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Galugarin ang Ilang Recipe!',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.orange,
                                  style: BorderStyle.solid,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Mga sikat na RECIPES',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                        ),
                        // Horizontal ListView of different clickable food items
                        Container(
                          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                          height: 125.0,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              _foodCard(
                                context,
                                'Kaldereta',
                                'assets/Kaldereta.jpg',
                                'A rich beef stew made with tomato sauce, potatoes, carrots, and other ingredients.',
                              ),
                              const SizedBox(width: 10.0),
                              _foodCard(
                                context,
                                'Bikol Express',
                                'assets/BicolExpress.jpg',
                                'isa sa mga kasama ang pagkaing maanghang A spicy dish from Bicol, made with pork, shrimp paste, coconut milk, and chilies.',
                              ),
                              const SizedBox(width: 10.0),
                              _foodCard(
                                context,
                                'Adobong Baboy',
                                'assets/PorkAdobo.jpg',
                                'isa sa mga sikat na pagkaing pinoy sa pilipinas Adobong Baboy binababad sa suka,toyo,bawang at sibuyas.',
                              ),
                              const SizedBox(width: 10.0),
                              _foodCard( // Added Sinigang to the list
                                context,
                                'Sinigang na Baboy',
                                'assets/SinigangB.jpg',
                                'Isipin ang pagpapakasawa sa isang mangkok ng tradisyonal na Filipino sour soup na nakakaakit sa iyong panlasa sa bawat kutsara. Ang kasiya-siyang ulam na ito ay ginawa gamit ang malambot na baboy o makatas na hipon, nilagyan ng makulay na tang ng tamarind, at puno ng sariwang gulay. Ang bawat masarap na kagat ay isang pagdiriwang ng mga lasa na nagpapainit sa puso at kaluluwa!.',
                              ),
                              const SizedBox(width: 10.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Ang Aming Itinatampok na Putahe!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    // Navigate to the FoodRecipePage for Sinigang
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodRecipe(
                          foodName: 'Sinigang na Baboy',
                          foodImage: 'assets/SinigangB.jpg',
                          recipeDetails:
                          'Isang tradisyonal na Filipino sour soup na gawa sa baboy, tamarind, at sariwang gulay.',
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Container(
                          height: 275.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/SinigangB.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Masarap at madaling gawin!',
                            style: GoogleFonts.poppins(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 3.0,
                            width: 250.0,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Food card widget with click functionality
  Widget _foodCard(BuildContext context, String foodName, String imagePath, String recipeDetails) {
    return GestureDetector(
      onTap: () {
        // Navigate to the FoodRecipePage with the selected food details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodRecipe(
              foodName: foodName,
              foodImage: imagePath,
              recipeDetails: recipeDetails,
            ),
          ),
        );
      },
      child: Container(
        height: 125.0,
        width: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              height: 125.0,
              width: 100.0,
            ),
            const SizedBox(width: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  foodName,
                  style: GoogleFonts.quicksand(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 2.0,
                  width: 75.0,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}