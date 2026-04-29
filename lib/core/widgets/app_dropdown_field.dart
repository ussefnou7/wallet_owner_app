import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    required this.items,
    this.fieldKey,
    this.value,
    this.label,
    this.hintText,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    super.key,
  });

  final Key? fieldKey;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: fieldKey,
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
