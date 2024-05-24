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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
