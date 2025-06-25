import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_svg/flutter_svg.dart'; // **الاستيراد الجديد والهام لملفات SVG**

// Assume these are your utility classes based on previous context
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/helper/my_responsive.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart'; // Re-using your custom button

// A simple data model for an App to hold its details
class AppData {
  final String name;
  final String usageTime;
  final String iconUrl;

  AppData({required this.name, required this.usageTime, required this.iconUrl});
}

class AppListScreen extends StatelessWidget {
  AppListScreen({super.key});

  // Mock list of diverse applications with SVG image URLs from SVG Repo
  final List<AppData> _apps = [
    // Social Media
    AppData(
      name: 'Facebook',
      usageTime: '20 min',
      iconUrl: 'https://img.icons8.com/color/48/facebook.png',
    ),
    AppData(
      name: 'Instagram',
      usageTime: '30 min',
      iconUrl: 'https://img.icons8.com/color/48/instagram-new.png',
    ),
    AppData(
      name: 'WhatsApp',
      usageTime: '45 min',
      iconUrl: 'https://img.icons8.com/color/48/whatsapp.png',
    ),
    AppData(
      name: 'TikTok',
      usageTime: '1 hr',
      iconUrl: 'https://img.icons8.com/color/48/tiktok.png',
    ),

    // Entertainment / Video Streaming
    AppData(
      name: 'YouTube',
      usageTime: '1 hr 15 min',
      iconUrl: 'https://img.icons8.com/color/48/youtube-play.png',
    ),
    AppData(
      name: 'Netflix',
      usageTime: '50 min',
      iconUrl: 'https://img.icons8.com/color/48/netflix-desktop-app.png',
    ),

    // Games
    AppData(
      name: 'PUBG Mobile',
      usageTime: '1 hr 30 min',
      iconUrl: 'https://img.icons8.com/color/48/pubg.png',
    ),
    AppData(
      name: 'Minecraft',
      usageTime: '1 hr',
      iconUrl: 'https://img.icons8.com/color/48/minecraft-logo.png',
    ),

    // Educational
    AppData(
      name: 'Duolingo',
      usageTime: '25 min',
      iconUrl: 'https://img.icons8.com/color/48/duolingo-logo.png',
    ),
    AppData(
      name: 'Khan Academy',
      usageTime: '35 min',
      iconUrl: 'https://img.icons8.com/color/48/khan-academy.png',
    ),

    // Browsers
    AppData(
      name: 'Chrome',
      usageTime: '40 min',
      iconUrl: 'https://img.icons8.com/color/48/chrome.png',
    ),

    // Utilities
    AppData(
      name: 'Gallery',
      usageTime: '10 min',
      iconUrl: 'https://img.icons8.com/color/48/picture.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'App List',
          style: TextStyle(
            color: Colors.black,
            fontSize: MyResponsive.width(context, value: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _apps.length,
        padding: EdgeInsets.symmetric(
          horizontal: MyResponsive.width(context, value: 16),
          vertical: MyResponsive.height(context, value: 8),
        ),
        itemBuilder: (context, index) {
          final app = _apps[index];
          return AppListItem(
            appName: app.name,
            appUsageTime: app.usageTime,
            appIconUrl: app.iconUrl,
          );
        },
      ),
    );
  }
}

class AppListItem extends StatefulWidget {
  final String appName;
  final String appUsageTime;
  final String appIconUrl;

  const AppListItem({
    super.key,
    required this.appName,
    required this.appUsageTime,
    required this.appIconUrl,
  });

  @override
  State<AppListItem> createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void _showSetTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  MyResponsive.width(context, value: 12),
                ),
              ),
              title: Text(
                widget.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MyResponsive.width(context, value: 20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _startTime = picked;
                            });
                          }
                        },
                        child: _TimeBox(
                          time: _formatTime(_startTime),
                        ),
                      ),
                      SizedBox(
                        width: MyResponsive.width(context, value: 10),
                      ),
                      Text(
                        'to',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: MyResponsive.width(context, value: 16),
                        ),
                      ),
                      SizedBox(
                        width: MyResponsive.width(context, value: 10),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _endTime = picked;
                            });
                          }
                        },
                        child: _TimeBox(
                          time: _formatTime(_endTime),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyResponsive.height(context, value: 15),
                  ),
                  CustomElevatedButton(
                    textButton: 'Done',
                    shadowColor: AppColors.yellowLight,
                    onPressed: () {
                      print(
                        'Selected time for ${widget.appName}: ${_formatTime(_startTime)} to ${_formatTime(_endTime)}',
                      );
                      Navigator.of(context).pop();
                    },
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.blue,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MyResponsive.height(context, value: 12)),
      padding: EdgeInsets.symmetric(
        horizontal: MyResponsive.width(context, value: 16),
        vertical: MyResponsive.height(context, value: 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MyResponsive.width(context, value: 10),
        ),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          // App Icon - **هذا هو الجزء الذي تم تعديله لعرض أيقونات SVG**
          ClipRRect(
            borderRadius: BorderRadius.circular(
              MyResponsive.width(context, value: 10),
            ),
            child: (widget.appIconUrl.toLowerCase().endsWith('.svg'))
                ? SvgPicture.network(
              widget.appIconUrl,
              width: MyResponsive.width(context, value: 50),
              height: MyResponsive.width(context, value: 50),
              fit: BoxFit.cover,
              placeholderBuilder: (BuildContext context) => Container(
                width: MyResponsive.width(context, value: 50),
                height: MyResponsive.width(context, value: 50),
                color: AppColors.yellowLight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                    strokeWidth: MyResponsive.width(context, value: 2),
                  ),
                ),
              ),
              // يمكنك إضافة errorBuilder هنا أيضاً إذا أردت معالجة أخطاء SVG
            )
                : Image.network(
              // هذا الجزء لصور PNG/JPG إذا كنت تستخدمها في القائمة
              widget.appIconUrl,
              width: MyResponsive.width(context, value: 50),
              height: MyResponsive.width(context, value: 50),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: MyResponsive.width(context, value: 50),
                  height: MyResponsive.width(context, value: 50),
                  color: AppColors.yellowLight,
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.blue,
                    size: MyResponsive.width(context, value: 30),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: MyResponsive.width(context, value: 16)),
          // App Name and Usage Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appName,
                  style: TextStyle(
                    fontSize: MyResponsive.width(context, value: 18),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.appUsageTime,
                  style: TextStyle(
                    fontSize: MyResponsive.width(context, value: 14),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Lock Icon
          Icon(
            Icons.lock_outline,
            color: Colors.grey,
            size: MyResponsive.width(context, value: 24),
          ),
          SizedBox(width: MyResponsive.width(context, value: 12)),
          // Clock Icon (Time Setting)
          GestureDetector(
            onTap: _showSetTimeDialog,
            child: Icon(
              Icons.access_time,
              color: Colors.grey,
              size: MyResponsive.width(context, value: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// Private widget for a single time display box (reused from SetTimeView)
class _TimeBox extends StatelessWidget {
  final String time;

  const _TimeBox({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MyResponsive.width(
          context,
          value: 17.0,
        ),
        vertical: MyResponsive.height(
          context,
          value: 10.0,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MyResponsive.width(context, value: 10.0),
        ),
        border: Border.all(color: AppColors.yellow, width: 1),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Colors.black,
          fontSize: MyResponsive.width(context, value: 17.0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}