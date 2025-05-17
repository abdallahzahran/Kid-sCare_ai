import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/features/home/widgets/custom_app_bar.dart';
import 'package:kidscare/features/home/widgets/custom_user_card.dart';
import 'package:kidscare/features/profile/views/profile.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/dashboard/views/dashboard_view.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/services/kids_service.dart';
import 'package:kidscare/features/profile/views/kids_info_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Kid> get kids => KidsService().kids
      .map((k) => Kid(name: k['name']!, avatarAsset: AppAssets.image))
      .toList();
  int selectedKid = 0;

  void switchKid(int index) {
    setState(() {
      selectedKid = index;
    });
  }

  void _goToKidsInfoView() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => KidsInfoView()));
    setState(() {}); // Refresh kids list after returning
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(),
        Expanded(
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
              CustomUserCard(
                kid: kids[selectedKid],
                onSwitchKid: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => SwitchKidSheet(
                    kids: kids,
                    selected: selectedKid,
                    onSelect: (i) {
                      switchKid(i);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Kid {
  final String name;
  final String avatarAsset;
  Kid({required this.name, required this.avatarAsset});
}

class SwitchKidSheet extends StatelessWidget {
  final List<Kid> kids;
  final int selected;
  final ValueChanged<int> onSelect;

  const SwitchKidSheet({
    super.key,
    required this.kids,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text('Switch Kids', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: kids.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(kids[i].name),
                selected: i == selected,
                onTap: () => onSelect(i),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
