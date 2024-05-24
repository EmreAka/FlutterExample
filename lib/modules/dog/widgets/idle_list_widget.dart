import 'package:flutter/material.dart';

class IdleListWidget extends StatelessWidget {
  const IdleListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}