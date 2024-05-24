import 'package:flutter/material.dart';

class FailedInformationWidget extends StatelessWidget {
  const FailedInformationWidget({
    super.key,
    required this.error,
  });

  final Exception error;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      children: [
        Center(
          child: Text(
            'Failed to load dogs: $error',
          ),
        ),
      ],
    );
  }
}
