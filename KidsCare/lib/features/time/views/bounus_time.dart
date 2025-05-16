import 'package:flutter/material.dart';
import 'package:kidscare/features/home/widgets/custom_action_btn.dart';

import '../../../core/helper/my_bottom_sheet.dart';
import '../../../core/helper/my_responsive.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/widget/custom_elvated_btn.dart';
import '../../../core/widget/custom_svg.dart';



class BounsTimeView extends StatelessWidget {
  const BounsTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionBottom(
      icon: CustomSvg(assetPath: AppAssets.bouns),
      onPressed: (){
        MyBottomSheet(
          height: MyResponsive.height(context, value: 458.5),
          context: context,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 400,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Hello from Bottom Sheet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  textButton: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
