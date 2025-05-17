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
      .map((k) => Kid(
            name: k['name']!,
            email: k['email']!,
            age: k['age']!,
            avatarAsset: AppAssets.image,
          ))
      .toList();
  int selectedKid = 0;

  @override
  void initState() {
    super.initState();
    // Load first kid from cache
    KidsService().loadFirstKidFromCache();
  }

  void switchKid(int index) {
    setState(() {
      selectedKid = index;
      // Update first kid in KidsService
      if (index < KidsService().kids.length) {
        KidsService().updateFirstKid(index);
      }
    });
  }

  void _goToKidsInfoView() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => KidsInfoView()));
    setState(() {}); // Refresh kids list after returning
  }

  @override
  Widget build(BuildContext context) {
    final currentKid = KidsService().kids.isNotEmpty 
        ? KidsService().kids[selectedKid]
        : null;
    
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
              if (currentKid != null)
                CustomUserCard(
                  kid: Kid(
                    name: currentKid['name']!,
                    email: currentKid['email']!,
                    age: currentKid['age']!,
                    avatarAsset: AppAssets.image,
                  ),
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
  final String email;
  final String age;
  final String avatarAsset;
  Kid({
    required this.name,
    required this.email,
    required this.age,
    required this.avatarAsset,
  });
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Switch Kids',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: kids.length,
              itemBuilder: (context, i) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(kids[i].avatarAsset),
                ),
                title: Text(kids[i].name),
                subtitle: Text('Age: ${kids[i].age}'),
                selected: i == selected,
                selectedTileColor: AppColors.yellowLight.withOpacity(0.3),
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
