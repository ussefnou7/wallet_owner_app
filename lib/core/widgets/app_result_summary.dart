import 'package:flutter/material.dart';

class AppResultSummary extends StatelessWidget {
  const AppResultSummary({required this.count, required this.label, super.key});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text('$count $label', style: Theme.of(context).textTheme.bodySmall);
  }
}
