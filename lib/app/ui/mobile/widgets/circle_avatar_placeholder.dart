import 'dart:math';

import 'package:flutter/material.dart';

class CircleAvatarPlaceholder extends StatelessWidget {
  final String text;

  CircleAvatarPlaceholder({Key? key, required this.text}) : super(key: key);

  final List<Color> randomColors = [Colors.indigo, Colors.indigoAccent, Colors.teal];

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: randomColors[Random().nextInt(randomColors.length)],
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
