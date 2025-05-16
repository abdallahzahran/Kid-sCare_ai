import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
class CustomCardProfile extends StatelessWidget {
  final String iconPath;
  final String text;
  const CustomCardProfile({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(

              children: [
                SvgPicture.asset(iconPath),
               SizedBox(width: 10,),
                Text('$text'),
                Spacer(),
                SvgPicture.asset(AppAssets.arrowBackRight),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
