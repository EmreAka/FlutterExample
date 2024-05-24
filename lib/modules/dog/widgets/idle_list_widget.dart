import 'package:flutter/material.dart';

class IdleListWidget extends StatelessWidget {
  const IdleListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}