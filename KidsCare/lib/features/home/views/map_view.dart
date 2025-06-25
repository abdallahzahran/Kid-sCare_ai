import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kidscare/core/utils/app_colors.dart'; // تأكد من المسار الصحيح لملف AppColors

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  // إحداثيات مركز الخريطة الافتراضي (يمكنك تغييرها)
  static const LatLng _center = LatLng(30.6033, 31.7337); // Tenth of Ramadan City, Egypt

  // مجموعة من العلامات (Markers) لعرضها على الخريطة
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('currentLocation'),
      position: _center,
      infoWindow: InfoWindow(title: 'موقع الطفل الحالي'),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white, // استخدم نفس لون الـ AppBar في تطبيقك
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () {
            Navigator.pop(context); // للعودة إلى الشاشة السابقة
          },
        ),
        title: const Text(
          'Live Location',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition( // ############## تم تصحيح هذا السطر ##############
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers, // إضافة العلامات إلى الخريطة
            myLocationButtonEnabled: true, // تفعيل زر موقعي
            zoomControlsEnabled: true, // تفعيل أزرار التكبير/التصغير
          ),
          // يمكنك إضافة زر تتبع الطفل هنا إذا أردت
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
                            child: const Icon(Icons.person, color: AppColors.blue), // يمكنك استبدالها بصورة الطفل
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ali Mohamed', // هذا الاسم يمكنك جعله ديناميكيًا لاحقًا
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                              ),
                              Text(
                                'First Kid', // هذا الوصف يمكنك جعله ديناميكيًا لاحقًا
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: أضف منطق تتبع الطفل هنا
                            print('Track Kid Tapped!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Track Kid',
                            style: TextStyle(
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
      ),
    );
  }
}