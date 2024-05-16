import 'package:flutter/material.dart';

class ExampleButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const ExampleButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
      ),
    );
  }
}
