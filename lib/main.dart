import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AllRestaurant.dart';
import 'RestaurantMenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider(
        create: (context) => xxx(),
        child: AllResturant(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
