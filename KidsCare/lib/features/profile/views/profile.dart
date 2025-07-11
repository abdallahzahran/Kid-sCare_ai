import 'package:flutter/material.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import '../../../core/helper/my_navigator.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widget/custom_card_profile.dart';
import '../../../core/services/kids_service.dart';
import 'edit_profile_view.dart';
import '../../time/views/bounus_time.dart';
import 'kids_info_view.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final parentName = KidsService().parentName ?? 'Parent';
    final parentPhotoPath = KidsService().parentPhotoPath;
    File? parentPhotoFile = parentPhotoPath != null ? File(parentPhotoPath) : null;
    bool photoExists = parentPhotoFile != null && parentPhotoFile.existsSync();
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(end: 16),
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: photoExists
                      ? ClipOval(child: Image.file(
                          parentPhotoFile!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ))
                      : ClipOval(child: Image.asset(
                          AppAssets.image,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        )),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      parentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 36),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.user,
                text: 'Update Profile',
              ),
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileView()),
                );
                if (updated == true) setState(() {});
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.kid,
                text: 'Kid Info',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KidsInfoView()),
                );
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.time,
                text: 'Give bouns',
              ),
              onTap: () async {
                final minutes = await BounusTimeView.showBounusTime(context);
                if (minutes != null) {
                  // TODO: Handle the bonus time minutes
                  print('Bonus time: $minutes minutes');
                }
              },
            ),
            const SizedBox(height: 16),
            // InkWell(
            //   child: CustomCardProfile(
            //     iconPath: AppAssets.settings,
            //     text: 'Settings',
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => HomeView()),
            //     );
            //   },
            // ),
            const SizedBox(height: 16),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.logOut,
                text: 'Log Out',
              ),
              onTap: () {
                MyNavigator.goTo(
                  screen: const LoginView(),
                  isReplace: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 