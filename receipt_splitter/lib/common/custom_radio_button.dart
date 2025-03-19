import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T)
  labelBuilder; // Function to get the label from option

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
          options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<T>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    if (value != null) {
                      onChanged(value);
                    }
                  },
                ),
                Text(labelBuilder(option)),
                const SizedBox(width: 10), // Space between items
              ],
            );
          }).toList(),
    );
  }
}
