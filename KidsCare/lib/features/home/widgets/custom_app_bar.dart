import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/features/notification/views/notification_view.dart';

import '../../../core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSvg(
            assetPath: AppAssets.logo,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationView()),
              );
            },
            child: CustomSvg(assetPath: AppAssets.notification),
          ),
        ],
      ),
    );
  }
}
