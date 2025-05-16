import 'package:flutter/material.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import '../../../core/helper/my_navigator.dart';
import '../../../core/helper/my_responsive.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widget/custom_card_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(end: 16),
                  height: MyResponsive.height(context, value: 60),
                  width: MyResponsive.height(context, value: 60),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AppAssets.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Text(
                      'Abdallah Zahran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),

            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.user,
                text: 'Update Profile',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.kid,
                text: 'Kid Info',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.settings,
                text: 'Settings',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              child: CustomCardProfile(
                iconPath: AppAssets.logOut,
                text: 'Log Out',
              ),
              onTap: () {
                MyNavigator.goTo(
                  screen: () => LoginView(),
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
