import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget implements PreferredSizeWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: LinearProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(1);
}