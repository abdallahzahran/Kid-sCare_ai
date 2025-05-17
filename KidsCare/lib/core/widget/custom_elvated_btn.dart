import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String textButton;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color shadowColor;


  const CustomElevatedButton({
    super.key,
    required this.textButton,
    required this.onPressed,
    this.backgroundColor = AppColors.yellow,
    this.foregroundColor = AppColors.blue,
    this.shadowColor = AppColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(

          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          alignment: Alignment.center,
          elevation: 5,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          textButton,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}