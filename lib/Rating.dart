import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Rate extends StatelessWidget {
  final int value;
  Rate(this.value);
  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      onRated: (v) {
      },
      starCount: 5,
      rating: value.toDouble(),
      size: 30.0,
      isReadOnly:true,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      color: Colors.green,
      borderColor: Colors.green,
    );
  }
}