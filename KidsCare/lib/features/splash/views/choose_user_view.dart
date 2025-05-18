import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/helper/my_navigator.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/features/kid/add_kid_view.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/helper/my_responsive.dart';

class ChooseUserView extends StatelessWidget {
  const ChooseUserView ({super.key});

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
                  onPressed: () {
                    CacheHelper.saveData(key: 'userType', value: 'parent');
                     MyNavigator.goTo(screen:  const RegisterView() ,isReplace: true);
                  },
                ),
                SizedBox(height: verticalSpacing),
                CustomElevatedButton(
                  textButton: 'Kid',
                  onPressed: () {
                    CacheHelper.saveData(key: 'userType', value: 'kid');
                    MyNavigator.goTo(screen:   RegisterKidView(),isReplace: true);
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