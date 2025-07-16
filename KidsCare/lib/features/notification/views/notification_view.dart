import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart'; // تأكد من وجود هذا الملف لموضوع الألوان
import 'package:kidscare/features/notification/views/noti_model.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الإشعارات التي تمثل أنشطة الطفل
    final List<NotificationModel> childActivitiesNotifications = [
      NotificationModel(
        title: 'Child opened YouTube',
        time: '10 minutes ago',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/1384/1384060.png', // مثال: أيقونة يوتيوب
      ),
      NotificationModel(
        title: 'Child downloaded TikTok',
        time: '3 hours ago',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3046/3046122.png', // مثال: أيقونة تيك توك
      ),
      NotificationModel(
        title: 'Child searched for "Dinosaur games"',
        time: '5 hours ago',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/54/54481.png', // مثال: أيقونة بحث
      ),
      NotificationModel(
        title: 'Child opened Netflix',
        time: 'Yesterday at 7 PM',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/732/732228.png', // مثال: أيقونة نتفليكس
      ),
      NotificationModel(
        title: 'Child installed "Minecraft"',
        time: '2 days ago',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/5969/5969018.png', // مثال: أيقونة ماينكرافت
      ),
      NotificationModel(
        title: 'Child browsed "Educational games website"',
        time: '3 days ago',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2920/2920256.png', // مثال: أيقونة موقع ويب
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Child Activities', // عنوان الصفحة
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
        padding: const EdgeInsets.symmetric(vertical: 16.0), // مسافة بادئة حول المحتوى
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم "New Activities" أو "الأنشطة الجديدة"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent Activities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // عرض الإشعارات باستخدام _NotificationCard
            ...childActivitiesNotifications.map((notification) => _NotificationCard(notification: notification)).toList(),
          ],
        ),
      ),
      backgroundColor: AppColors.white, // استخدام لون الخلفية من AppColors
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification; // استقبال كائن NotificationModel

  const _NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5), // لون خلفية البطاقة
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // مكان عرض الصورة
          Container(
            width: 50, // حجم أكبر قليلاً للصورة
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300], // لون خلفية افتراضي لمكان الصورة
              borderRadius: BorderRadius.circular(10), // حواف دائرية أكثر
            ),
            child: notification.imageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                notification.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover, // تأكد من أن الصورة تملأ المساحة بشكل مناسب
                // معالج الأخطاء في حال فشل تحميل الصورة
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.grey, size: 30);
                },
                // مؤشر تحميل (اختياري)
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            )
                : const Icon(Icons.event_note, color: Colors.grey, size: 30), // أيقونة افتراضية إذا لم تكن هناك صورة
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title, // عنوان النشاط
                  style: const TextStyle(
                    fontWeight: FontWeight.w600, // خط سميك قليلاً
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2, // قد يكون العنوان طويلاً
                  overflow: TextOverflow.ellipsis, // لقطع النص الزائد
                ),
                const SizedBox(height: 6),
                Text(
                  notification.time, // وقت النشاط
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          //const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18), // أيقونة للإشارة إلى التفاصيل
        ],
      ),
    );
  }
}