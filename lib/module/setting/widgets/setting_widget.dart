import 'package:flutter/material.dart';

class SettingActionWidget extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String label;
  const SettingActionWidget(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(
        label,
      ),
      icon: Icon(
        icon,
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
