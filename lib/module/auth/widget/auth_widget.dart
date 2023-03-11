import 'package:flutter/material.dart';

class IconLoginOptional extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  const IconLoginOptional({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          // color: AppColors.light,
        ),
      ),
    );
  }
}
