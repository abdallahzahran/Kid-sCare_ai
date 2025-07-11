import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/utils/app_assets.dart';

import '../../../core/widget/custom_svg.dart' show CustomSvg;

class LiveDisplayView extends StatefulWidget {
  const LiveDisplayView({super.key});

  @override
  State<LiveDisplayView> createState() => _LiveDisplayViewState();
}

class _LiveDisplayViewState extends State<LiveDisplayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () {
            Navigator.pop(context); // للعودة إلى الشاشة السابقة
          },
        ),
        title: const Text(
          'Live Display',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(
            //   child: Center(
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200], // لون خلفية الكارد
            //           borderRadius: BorderRadius.circular(15.0),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.3),
            //               spreadRadius: 2,
            //               blurRadius: 5,
            //               offset: const Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(15.0),
            //           child: Image.asset(
            //             AppAssets.liveDisplayImage, // ############## مسار الصورة هنا ##############
            //             fit: BoxFit.cover, // لجعل الصورة تغطي المساحة المتاحة مع الحفاظ على الأبعاد
            //             // يمكنك إضافة placeholder أو errorBuilder هنا لتحسين تجربة المستخدم
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Spacer(flex: 2,),
            CustomSvg(assetPath: AppAssets.scr,width: 200,height: 200,),
            Text("No display Screen now",
              style: TextStyle(
              fontSize: 18,
              color: AppColors.grayDark2, // لون النص من AppColors
            ),),
            Spacer(flex: 3,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('Take screen shot button tapped!');
                    // TODO: أضف منطق عمل زر "Take screen shot" هنا
                    // قد يتضمن هذا إرسال أمر إلى الجهاز الآخر لالتقاط لقطة شاشة.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow, // لون الزر من AppColors
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    'Take screen shot',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue, // لون النص من AppColors
                    ),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1,),
          ],
        ),
      ),
    );
  }
}