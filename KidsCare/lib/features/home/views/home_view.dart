import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/features/home/widgets/custom_app_bar.dart';
import 'package:kidscare/features/home/widgets/custom_user_card.dart';
import 'package:kidscare/features/profile/views/profile.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/dashboard/views/dashboard_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    ProfileView(),
    DashboardView(),
    Center(child: Text('School Page', style: TextStyle(fontSize: 22))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.yellowLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 5,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined,color: AppColors.blue,),
            selectedIcon: Icon(Icons.home,color: AppColors.yellow,),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined,color: AppColors.blue,),
            selectedIcon: Icon(Icons.person_2,color: AppColors.yellow,),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined,color: AppColors.blue,),
            selectedIcon: Icon(Icons.dashboard,color: AppColors.yellow,),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
                CustomUserCard(),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}
