import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String? description;
  const EmptyScreen({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          if (description != null) ...[
            const SizedBox(height: 10),
            Text(description!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}
