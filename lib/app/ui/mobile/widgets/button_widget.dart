import 'package:flutter/material.dart';

class RaisedButtonCustomWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  final Color backgroundColor;

  const RaisedButtonCustomWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(backgroundColor)),
      onPressed: onPressed,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(text),
          Icon(icon),
        ],
      ),
    );
  }
}
