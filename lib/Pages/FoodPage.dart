import 'package:flutter/material.dart';
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE4EC), // Pink tone (example from ChangePassword)
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
                            child: const Text(
                              'Explore Some Recipes!',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
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
                            children: const <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'POPULAR RECIPES',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Timesroman',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                              'Bicol Express',
                              'assets/BicolExpress.jpg',
                              'A spicy dish from Bicol, made with pork, shrimp paste, coconut milk, and chilies.',
                            ),
                            const SizedBox(width: 10.0),
                            _foodCard(
                              context,
                              'Pork Adobo',
                              'assets/PorkAdobo.jpg',
                              'A popular Filipino dish made from pork marinated in soy sauce, vinegar, garlic, and spices.',
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
                child: const Text(
                  'Try Our Featured Recipe!',
                  style: TextStyle(
                    fontFamily: 'Timesroman',
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
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
                        foodName: 'Sinigang',
                        foodImage: 'assets/SinigangB.jpg',
                        recipeDetails:
                        'A traditional Filipino sour soup made with pork or shrimp, tamarind, and fresh vegetables.',
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
                        const Text(
                          'Delicious and Easy to Make!',
                          style: TextStyle(
                            fontFamily: 'Timesroman',
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 3.0,
                          width: 50.0,
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
                  style: const TextStyle(fontFamily: 'Quicksand'),
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
