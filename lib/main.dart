import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AllRestaurant.dart';
import 'FavouriteModel.dart';
import 'OrderModel.dart';
import 'RestaurantMenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavModel()),
        ChangeNotifierProvider(create: (context) => OrderModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AllResturant(),
      ),
    );
  }
}