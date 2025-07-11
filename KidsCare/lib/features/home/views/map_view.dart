import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/services/kids_service.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import '../../../core/utils/app_assets.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  LatLng _currentKidLocation = const LatLng(30.6033, 31.7337);
  int _selectedKidIndex = 0;

  final KidsService _kidsService = KidsService();

  // ##################### التعديل هنا #####################
  // اجعلها Set قابلة للتعديل
  final Set<Marker> _markers = {}; // ابدأ بمجموعة فارغة
  // #######################################################

  @override
  void initState() {
    super.initState();
    _initializeSelectedKid();
    _kidsService.kidsNotifier.addListener(_onKidsListChanged);
  }

  @override
  void dispose() {
    _kidsService.kidsNotifier.removeListener(_onKidsListChanged);
    super.dispose();
  }

  void _onKidsListChanged() {
    _initializeSelectedKid();
    // ليس هناك حاجة لاستدعاء _updateMapAndMarker() هنا مباشرة
    // لأن ValueListenableBuilder في الـ build ميثود سيعيد بناء الـ Widget
    // ومع إعادة البناء، سيتم استدعاء _onMapCreated (إذا كانت الخريطة لا تزال تُنشأ)
    // أو سيتم تحديث الـ markers من خلال الـ setState في _updateMapAndMarker
  }

  void _initializeSelectedKid() {
    if (_kidsService.kids.isNotEmpty) {
      _selectedKidIndex = _kidsService.firstKidIndex < _kidsService.kids.length
          ? _kidsService.firstKidIndex
          : 0;
      // يمكنك هنا تحديث _currentKidLocation بناءً على بيانات الطفل الفعلي
      // إذا كانت بيانات الموقع مخزنة في KidsService
      // _currentKidLocation = LatLng(double.parse(_kidsService.kids[_selectedKidIndex]['lat']!), double.parse(_kidsService.kids[_selectedKidIndex]['lon']!));
    } else {
      _selectedKidIndex = 0;
      _currentKidLocation = const LatLng(30.6033, 31.7337);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMapAndMarker(); // تحديث الخريطة بمجرد إنشائها
  }

  void _updateMapAndMarker() {
    setState(() {
      _markers.clear();
      if (_kidsService.kids.isNotEmpty) {
        final currentKid = _kidsService.kids[_selectedKidIndex];
        // استخدم الموقع الافتراضي إذا لم يكن لديك مواقع حقيقية
        final LatLng kidLoc = _currentKidLocation; // أو موقع الطفل الفعلي

        _markers.add(
          Marker(
            markerId: MarkerId(currentKid['email']!),
            position: kidLoc,
            infoWindow: InfoWindow(
              title: currentKid['name'],
              snippet: 'Age: ${currentKid['age']}',
            ),
          ),
        );
        // تحريك الكاميرا إلى موقع الطفل الجديد
        mapController.animateCamera(CameraUpdate.newLatLngZoom(kidLoc, 15.0));
      }
    });
  }

  void _switchKid(int index) {
    if (index >= 0 && index < _kidsService.kids.length) {
      setState(() {
        _selectedKidIndex = index;
        _kidsService.updateFirstKid(index); // تحديث الطفل الأول في الخدمة
      });
      _updateMapAndMarker(); // تحديث الخريطة والماركر للطفل الجديد
      Navigator.pop(context); // إغلاق الـ BottomSheet بعد الاختيار
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Live Location',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: _kidsService.kidsNotifier,
        builder: (context, kidsList, child) {
          final currentKidData = kidsList.isNotEmpty
              ? kidsList[_selectedKidIndex]
              : null;

          // تأكد من تحديث _selectedKidIndex هنا أيضًا إذا تغيرت قائمة الأطفال
          // أو إذا أصبح الفهرس الحالي غير صالح (مثال: تم حذف الطفل المحدد)
          if (_selectedKidIndex >= kidsList.length && kidsList.isNotEmpty) {
            _selectedKidIndex = 0; // ارجع إلى الطفل الأول
          } else if (kidsList.isEmpty) {
            _selectedKidIndex = 0;
          }
          // لا تستخدم setState هنا، لأنه داخل الـ builder.
          // القيم التي تعتمد عليها الـ builder سيتم تحديثها تلقائيا.

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentKidLocation,
                  zoom: 15.0,
                ),
                markers: _markers, // تم تحديثها في _updateMapAndMarker
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.person, color: AppColors.blue),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentKidData?['name'] ?? 'No Kid Selected',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      currentKidData != null ? 'Age: ${currentKidData['age']}' : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (kidsList.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.compare_arrows, color: AppColors.blue),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) => SwitchKidSheet(
                                        kids: kidsList.map((k) => Kid(
                                          name: k['name']!,
                                          email: k['email']!,
                                          age: k['age']!,
                                          avatarAsset: AppAssets.image,
                                        )).toList(),
                                        selected: _selectedKidIndex,
                                        onSelect: _switchKid,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (currentKidData != null) {
                                  print('Tracking ${currentKidData['name']}!');
                                } else {
                                  print('No kid to track!');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                currentKidData != null ? 'Track ${currentKidData['name']}' : 'No Kid to Track',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}