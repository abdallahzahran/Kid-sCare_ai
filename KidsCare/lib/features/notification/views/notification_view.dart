import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/widget/custom_svg.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSvg(assetPath: AppAssets.noti),
            // Tabs
            // Container(
            //   color: Colors.white,
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Column(
            //           children: [
            //             const SizedBox(height: 8),
            //             const Text(
            //               'All',
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 18,
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.only(top: 8),
            //               height: 2,
            //               color: Colors.black,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 16),
            // // New
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     'New',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // ...List.generate(3, (index) => _NotificationCard()),
            // const SizedBox(height: 16),
            // // Past notifications
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     'Past notifications',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // ...List.generate(3, (index) => _NotificationCard()),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
    );
  }
}

// class _NotificationCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE5E5E5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.grey[400],
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'install APP\nFacebook',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   '3 h',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.more_horiz, color: Colors.black54),
//         ],
//       ),
//     );
//   }
// }