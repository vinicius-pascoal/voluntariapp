import 'package:flutter/material.dart';

class BullamRetro extends StatelessWidget {
  const BullamRetro({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        child: Center(child: Icon(Icons.arrow_back_ios_new)),
      ),
    );
  }
}
