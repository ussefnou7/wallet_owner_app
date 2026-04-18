import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

class FilterChipOption<T> {
  const FilterChipOption({required this.value, required this.label});

  final T value;
  final String label;
}

class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    super.key,
  });

  final List<FilterChipOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(option.label),
            selected: option.value == selectedValue,
            onSelected: (_) => onSelected(option.value),
          ),
      ],
    );
  }
}
