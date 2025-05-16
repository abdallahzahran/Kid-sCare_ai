import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_constants.dart';

class ChooseUserView extends StatelessWidget {
  const ChooseUserView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppConstants.sizedBoxHeight(context, 0.1),
            CustomSvg(assetPath: AppAssets.logo),
            CustomElevatedButton(
              textButton: 'Parent',
              onPressed: () {
                CacheHelper.saveData(key: 'userType', value: 'parent');
                Get.toNamed('/registerParent');
              },
            ),
            CustomElevatedButton(
              textButton: 'Kid',
              onPressed: () {
                CacheHelper.saveData(key: 'userType', value: 'kid');
                Get.toNamed('/registerKid');
              },
            ),
            AppConstants.sizedBoxHeight(context, 0.1),
          ],
        ),
      ),
    );
  }
}