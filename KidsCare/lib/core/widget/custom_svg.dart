// custom_svg_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvg extends StatelessWidget {
  final String assetPath;
  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;


  const CustomSvg({
    super.key,
    required this.assetPath,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
    );
  }
}
