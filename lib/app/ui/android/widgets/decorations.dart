import 'package:flutter/material.dart';
import 'package:track_wealth/app/ui/theme/app_color.dart';

InputDecoration myInputDecoration = InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  isDense: true,
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: blueColor),
    borderRadius: BorderRadius.circular(10),
  ),
);

BoxDecoration eachFieldDecoration = BoxDecoration(
  border: Border.all(color: blueColor),
  borderRadius: BorderRadius.circular(15.0),
);
