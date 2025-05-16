import 'package:flutter/material.dart';
class CustomActionBottom extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const CustomActionBottom({required this.icon, required this.onPressed, });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       IconButton(onPressed: onPressed, icon: icon),

      ],
    );
  }
}