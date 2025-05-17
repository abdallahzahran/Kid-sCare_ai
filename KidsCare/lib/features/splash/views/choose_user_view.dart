import 'package:flutter/material.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/helper/my_responsive.dart';
import '../../../core/services/navigation_service.dart';

class ChooseUserView extends StatelessWidget {
  const ChooseUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = MyResponsive.height(context, value: 40);
    final double maxFormWidth = MyResponsive.width(context, value: 350);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxFormWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: verticalSpacing),
                CustomSvg(assetPath: AppAssets.logo),
                SizedBox(height: verticalSpacing),
                CustomElevatedButton(
                  textButton: 'Parent',
                  onPressed: () async {
                    await CacheHelper.saveUserType('parent');
                    NavigationService.toRegister();
                  },
                ),
                SizedBox(height: verticalSpacing),
                CustomElevatedButton(
                  textButton: 'Kid',
                  onPressed: () async {
                    await CacheHelper.saveUserType('kid');
                    NavigationService.toRegister();
                  },
                ),
                SizedBox(height: verticalSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}