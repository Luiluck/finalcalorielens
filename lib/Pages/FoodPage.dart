import 'dart:ui';
import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);  // Swipe right to go back
        }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Color(getColorHexFromStr('#fff5ea')),
                ),
                Column(
                  children: <Widget>[
                    // Welcome Container in place of the search bar
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 10.0),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(25.0),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          alignment: Alignment.center,
                          child: Text(
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
                    SizedBox(height: 15.0),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Colors.orange,
                                    style: BorderStyle.solid,
                                    width: 3.0))),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('POPULAR RECIPES',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Timesroman',
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                    ),
                    // Horizontal ListView of different clickable food items
                    Container(
                      padding: EdgeInsets.only(top: 15.0, left: 15.0),
                      height: 125.0,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _foodCard(
                            context,
                            'Grilled Chicken',
                            'assets/Food1.jpg',
                          ),
                          SizedBox(width: 10.0),
                          _foodCard(
                            context,
                            'Pasta Primavera',
                            'assets/Food2.jpg',
                          ),
                          SizedBox(width: 10.0),
                          _foodCard(
                            context,
                            'Vegan Salad',
                            'assets/Food3.jpg',
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Try Our Featured Recipe!',
                style: TextStyle(
                    fontFamily: 'Timesroman',
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
            SizedBox(height: 10.0),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Container(
                    height: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: AssetImage('assets/Food2.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Delicious and Easy to Make!',
                      style: TextStyle(
                        fontFamily: 'Timesroman',
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 3.0,
                      width: 50.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Color conversion helper function
  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  // Food card widget with click functionality
  Widget _foodCard(BuildContext context, String foodName, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Action when food card is tapped, e.g., navigate to details page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicked on $foodName')),
        );
      },
      child: Container(
        height: 125.0,
        width: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      image: AssetImage(imagePath), fit: BoxFit.cover)),
              height: 125.0,
              width: 100.0,
            ),
            SizedBox(width: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  foodName,
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
                SizedBox(height: 10.0),
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
