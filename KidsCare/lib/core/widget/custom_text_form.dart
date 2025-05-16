import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kidscare/core/helper/my_validator.dart';
import 'package:kidscare/core/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final TextEditingController? controller;
  final AppValidator validator;
  final Function()? onSuffixIconTap;
  final TextStyle textStyle;
  final double? horizontalPadding;

  const CustomTextFormField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.prefixIconPath,
    this.suffixIconPath,
    this.controller,
    required this.validator,
    this.onSuffixIconTap,
    required this.textStyle,this.horizontalPadding,
  }) : super(key: key);

  Widget _buildIcon(String path) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: SvgPicture.asset(
        path,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:horizontalPadding??16 , vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator.validate,
        obscureText: obscureText,
        style: textStyle,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon:
          prefixIconPath != null ? _buildIcon(prefixIconPath!) : null,
          suffixIcon: suffixIconPath != null
              ? GestureDetector(
            onTap: onSuffixIconTap,
            child: _buildIcon(suffixIconPath!),
          )
              : null,
          filled: false,
          fillColor: Colors.white,
          focusColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.yellow, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
