import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.filled = false,
    this.size = 48,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return SizedBox(
        width: size,
        height: size,
        child: Tooltip(
          message: tooltip,
          child: FloatingActionButton.small(
            onPressed: onPressed,
            child: Icon(icon, size: 24),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Tooltip(
        message: tooltip,
        child: IconButton.outlined(
          onPressed: onPressed,
          tooltip: tooltip,
          icon: Icon(icon, size: 22),
        ),
      ),
    );
  }
}
