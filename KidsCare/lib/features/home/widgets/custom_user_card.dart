import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import '../../../core/helper/my_navigator.dart';
import '../../../core/utils/app_colors.dart';
import '../../kid/app_list_view.dart';
import '../../kid/history_calls_view.dart';
import '../../time/views/bounus_time.dart';
import '../../time/views/set_time_view.dart';
import 'custom_action_btn.dart';
import '../../home/views/home_view.dart'; // تأكد من أن هذا الاستيراد يشير إلى تعريف Kid

class CustomUserCard extends StatelessWidget {
  final Kid kid;
  final VoidCallback onSwitchKid;

  const CustomUserCard({
    super.key,
    required this.kid,
    required this.onSwitchKid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // يمكنك إضافة صورة الطفل هنا إذا أردت
              // CircleAvatar(backgroundImage: AssetImage(kid.avatarAsset)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kid.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFBB600),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Age: ${kid.age}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    kid.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // تمت إزالة RegisterKidView() من هنا
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.switchKid),
                onPressed: onSwitchKid,
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                onPressed: () {
                  MyNavigator.goTo(screen:  AppListScreen());
                },
              ),
              CustomActionBottom(
                icon: CustomSvg(assetPath: AppAssets.calls),
                onPressed: () { MyNavigator.goTo(screen:  HistoryScreen());},
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
                child: const Text('Lock',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}