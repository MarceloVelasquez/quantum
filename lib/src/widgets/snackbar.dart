import 'package:flutter/material.dart';

showSnack(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
