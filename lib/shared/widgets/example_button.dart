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
      style: ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => const TextStyle(color: Colors.white),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
      ),
    );
  }
}
