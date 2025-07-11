import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  // للتحكم في التبويبات
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.pop(context);
          },
        ),
        title: const Text('History Calls & SMS'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calls'), // تبويب المكالمات
            Tab(text: 'SMS'), // تبويب الرسائل
          ],
          labelColor: Colors.black, // لون النص للتبويب النشط
          unselectedLabelColor: Colors.grey, // لون النص للتبويبات غير النشطة
          indicatorColor: Colors.blue, // لون المؤشر تحت التبويب النشط
        ),
      ),
      body: TabBarView(
        controller: _tabController, // ربط الـ TabBarView بالـ TabController
        children: const [
          CallsList(), // محتوى تبويب المكالمات
          SmsList(), // محتوى تبويب الرسائل
        ],
      ),
    );
  }
}

// Widget لعرض قائمة المكالمات
class CallsList extends StatelessWidget {
  const CallsList({super.key});

  // بيانات وهمية للمكالمات
  final List<Map<String, String>> calls = const [
    {
      'name': 'Ali Mohamed',
      'number': '+2 01028865565',
      'time': '10:04 PM',
      'icon': 'call_received', // أو يمكنك استخدام مسار صورة
    },
    {
      'name': 'Yousef Marwan',
      'number': '+2 01125861595',
      'time': '7:04 PM',
      'icon': 'call_received',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return Card(
          color: AppColors.white,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // الصورة الدائرية (يمكن استبدالها بصورة حقيقية أو أول حرف من الاسم)
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: const BoxDecoration(
                //     color: Colors.amber, // لون أصفر كما في الصورة
                //     shape: BoxShape.circle,
                //   ),
                //   // child: Center(
                //   //   child: Text(
                //   //     call['name']![0], // أول حرف من الاسم
                //   //     style: const TextStyle(color: Colors.white, fontSize: 20),
                //   //   ),
                //   // ),
                // ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            call['icon'] == 'call_received' ? Icons.call_received : Icons.call_made,
                            size: 18,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            call['number']!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  call['time']!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget لعرض قائمة الرسائل النصية
class SmsList extends StatelessWidget {
  const SmsList({super.key});

  // بيانات وهمية للرسائل
  final List<Map<String, String>> sms = const [
    {
      'sender': 'Orange',
      'message': 'Length of one SMS includes up to 160 English characters or 70 Arabic',
      'time': 'Just now',
    },
    {
      'sender': 'Vodafone',
      'message': 'Length of one SMS includes up to 160 English characters or 70 Arabic',
      'time': '10 m',
    },
    {
      'sender': 'Etisalat',
      'message': 'Length of one SMS includes up to 160 English characters or 70 Arabic',
      'time': '1 h',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: sms.length,
      itemBuilder: (context, index) {
        final message = sms[index];
        return Card(
          color: AppColors.white,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // الصورة الدائرية
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: const BoxDecoration(
                //     color: Colors.amber, // لون أصفر كما في الصورة
                //     shape: BoxShape.circle,
                //   ),
                //   // child: Center(
                //   //   child: Text(
                //   //     message['sender']![0], // أول حرف من اسم المرسل
                //   //     style: const TextStyle(color: Colors.white, fontSize: 20),
                //   //   ),
                //   // ),
                // ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['sender']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        message['message']!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                        maxLines: 2, // عرض سطرين كحد أقصى للرسالة
                        overflow: TextOverflow.ellipsis, // إضافة نقاط (...) إذا كانت الرسالة أطول
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message['time']!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 8.0), // مسافة بين الوقت والسهم
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}