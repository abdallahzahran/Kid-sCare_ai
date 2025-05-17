import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/features/kid/add_kid_view.dart';
import '../../../core/helper/my_navigator.dart';
import '../../../core/helper/my_responsive.dart';
import '../../../core/utils/app_colors.dart';
import '../../auth/views/login_view.dart';
import '../../time/views/bounus_time.dart';
import '../../time/views/set_time_view.dart';
import 'custom_action_btn.dart';
import '../../home/views/home_view.dart';

class CustomUserCard extends StatelessWidget {
  final Kid kid;
  final VoidCallback onSwitchKid;

  const CustomUserCard({super.key, required this.kid, required this.onSwitchKid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsetsDirectional.only(end: 16),
                  height: MyResponsive.height(context, value: 60),
                  width: MyResponsive.height(context, value: 60),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(kid.avatarAsset),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                onTap: () {
                  MyNavigator.goTo(screen: LoginView());
                },
              ),
              SizedBox(width: 12),
              Text(
                kid.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFBB600),
                ),
              ),
              Spacer(),
              RegisterKidView(),
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.switchKid),
                onPressed: onSwitchKid,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SetTimeView(),
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.bouns),
                onPressed: () async {
                  final minutes = await BounusTimeView.showBounusTime(context);
                  if (minutes != null) {
                    print('Bonus time: $minutes minutes');
                  }
                },
              ),
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.app),
                onPressed: () {},
              ),
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.calls),
                onPressed: () {},
              ),
              ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.blue,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 37.0,
                    vertical: 10.0,
                  ),
                ),
                child: Text('Lock',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
