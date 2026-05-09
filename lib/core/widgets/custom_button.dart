import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isOutlined = false,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isOutlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return icon != null
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(text),
            );
    }

    return icon != null
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text),
          )
        : FilledButton(
            onPressed: onPressed,
            child: Text(text),
          );
  }
}
