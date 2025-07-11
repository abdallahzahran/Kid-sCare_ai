import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kidscare/core/helper/my_navigator.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/features/home/widgets/custom_app_bar.dart';
import 'package:kidscare/features/home/widgets/custom_user_card.dart';
import 'package:kidscare/features/profile/views/profile.dart';
import 'package:kidscare/features/dashboard/views/dashboard_view.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/services/kids_service.dart';
import 'package:kidscare/features/profile/views/kids_info_view.dart';
import 'package:kidscare/features/home/views/map_view.dart';

import '../../../core/widget/custom_svg.dart';
import '../../kid/add_kid_view.dart' show RegisterKidView;
import '../widgets/custom_action_btn.dart';
import 'classify_view.dart';
import 'live_display_view.dart';

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
    const Center(child: Text('School Page', style: TextStyle(fontSize: 22))), // يمكنك استبدالها بصفحة مخصصة لاحقًا
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
            icon: Icon(Icons.home_outlined, color: AppColors.blue),
            selectedIcon: Icon(Icons.home, color: AppColors.yellow),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined, color: AppColors.blue),
            selectedIcon: Icon(Icons.person_2, color: AppColors.yellow),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: AppColors.blue),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.yellow),
            label: 'Dashboard',
          ),
          // يمكنك إضافة NavigationDestination أخرى لـ 'School Page' إذا لزم الأمر
        ],
      ),
      // ############### إضافة FloatingActionButton هنا ###############
      floatingActionButton: _selectedIndex == 0 // أظهر الزر فقط في HomeTab
          ? CustomActionBottom(
        icon: CustomSvg(assetPath: AppAssets.addKid),
        onPressed: () {
          MyNavigator.goTo(screen: RegisterKidView(
            onKidAdded: (newKidData) {
              // لا تحتاج لعمل أي شيء هنا، ValueListenableBuilder في HomeTab سيتكفل بالتحديث
            },
          ));
        },
      )
          : null, // لا تظهر الزر في الصفحات الأخرى
      // ##############################################################
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // يمكنك تعديل الموقع
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedKid = 0;

  @override
  void initState() {
    super.initState();
    // لا تحتاج لـ loadFromCache هنا بعد الآن لأنها تستدعى في تهيئة KidsService
  }

  void switchKid(int index) {
    setState(() {
      selectedKid = index;
      // تحديث الطفل الأول في KidsService
      if (index < KidsService().kids.length) { // لاحظ أن kids هنا ستأتي من ValueNotifier
        KidsService().updateFirstKid(index);
      }
    });
  }

  void _goToKidsInfoView() async {
    // الانتقال إلى صفحة معلومات الأطفال
    await Navigator.push(context, MaterialPageRoute(builder: (_) => KidsInfoView()));
    // ليست هناك حاجة لـ setState هنا لأن KidsService.kidsNotifier ستتولى التحديث
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
                // ############## استخدام ValueListenableBuilder هنا ##############
                ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: KidsService().kidsNotifier, // الاستماع إلى kidsNotifier
                  builder: (context, kidsList, child) {
                    final currentKid = kidsList.isNotEmpty
                        ? kidsList[selectedKid]
                        : null;

                    // تأكد من أن selectedKid لا يتجاوز حجم القائمة
                    if (selectedKid >= kidsList.length && kidsList.isNotEmpty) {
                      selectedKid = 0; // أو أي منطق آخر لإعادة تعيينه
                    } else if (kidsList.isEmpty) {
                      selectedKid = 0;
                    }

                    return Column(
                      children: [
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
                                kids: kidsList.map((k) => Kid(
                                  name: k['name']!,
                                  email: k['email']!,
                                  age: k['age']!,
                                  avatarAsset: AppAssets.image,
                                )).toList(),
                                selected: selectedKid,
                                onSelect: (i) {
                                  switchKid(i);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'No kids added yet. Please add a child to get started.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, color: AppColors.blue),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        MyNavigator.goTo(screen: RegisterKidView(
                                          onKidAdded: (newKidData) {
                                            // لا يزال يجب تمرير الدالة لأن RegisterKidView تتوقعها،
                                            // لكن لا تحتاج لعمل أي شيء هنا لأن ValueListenableBuilder سيتكفل بالتحديث
                                          },
                                        ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.yellowLight,
                                        foregroundColor: AppColors.blue,
                                      ),
                                      child: const Text('Add New Kid'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                // ##############################################################

                const CurrentLocationSection(),
               // const SizedBox(height: 10.0),
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(children: [
                   CustomFeatureButton(
                   text: 'Classify content',
                   icon: Icons.notes,
                   onTap: () {
                     MyNavigator.goTo(screen: ClassifyContentView());
                   },
                 ),
                   const SizedBox(height: 15.0),
                   CustomFeatureButton(
                     text: 'Live Display',
                     icon: Icons.remove_red_eye_outlined,
                     onTap: () {
                       MyNavigator.goTo(screen: LiveDisplayView());
                     },
                   ),],
                 ),
               ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentLocationSection extends StatefulWidget {
  const CurrentLocationSection({super.key});

  @override
  State<CurrentLocationSection> createState() => _CurrentLocationSectionState();
}

class _CurrentLocationSectionState extends State<CurrentLocationSection> {
  late GoogleMapController mapController;

  static const LatLng _center = LatLng(30.6033, 31.7337);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 12.0),
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: 270,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: _center,
                        zoom: 15.0,
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      markers: {
                        const Marker(
                          markerId: MarkerId('smallMapLocation'),
                          position: _center,
                        ),
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              MyNavigator.goTo(screen: MapView());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Explore Location',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CustomFeatureButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const CustomFeatureButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.blue, size: 28),
              const SizedBox(width: 15.0),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
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