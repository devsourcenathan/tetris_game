import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  var color;
  var child;
  Pixel({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          child,
          style: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
