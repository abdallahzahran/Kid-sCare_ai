import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';

class HistoryItem {
  final String time;
  final String date;
  final String content;

  HistoryItem({required this.time, required this.date, required this.content});
}

class ClassifyContentView extends StatefulWidget {
  const ClassifyContentView({super.key});

  @override
  State<ClassifyContentView> createState() => _ClassifyContentViewState();
}

class _ClassifyContentViewState extends State<ClassifyContentView> {

  final TextEditingController _badWordsController = TextEditingController();

  final List<String> _categories = [
    'مخدرات',
    'كحول',
    'قمار',
    'إباحية',
    'عنف',
    'إرهاب',
    'احتيال',

  ];


  final List<String> _blockWords = [
    'عنف',
    'عنف',
    'إرهاب',
    'احتيال',
    'عنف',
    'إرهاب',
    'احتيال',
  ];


  final List<HistoryItem> _history = [
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'احتيال'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'عنف'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'إرهاب'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'إباحية'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'قمار'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'مخدرات'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'احتيال'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'عنف'),
    HistoryItem(time: '10:00 AM', date: '2/10/2025', content: 'إرهاب'),
    HistoryItem(time: '11:00 AM', date: '2/10/2025', content: 'محتوى جديد'),
  ];

  @override
  void dispose() {
    _badWordsController.dispose();
    super.dispose();
  }


  void _addBlockWord() {
    if (_badWordsController.text.isNotEmpty) {
      setState(() {
        _blockWords.add(_badWordsController.text);

        _history.insert(0, HistoryItem(time: _getCurrentTime(), date: _getCurrentDate(), content: _badWordsController.text));
        _badWordsController.clear();
      });
    }
  }


  void _removeBlockWord(int index) {
    setState(() {
      _blockWords.removeAt(index);
    });
  }


  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour < 12 ? 'AM' : 'PM'}';
  }


  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.month}/${now.day}/${now.year}';
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
            Navigator.pop(context);          },
        ),
        title: const Text(
          'Classify Content',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم أزرار الفئات
              Wrap(
                spacing: 8.0, // المسافة الأفقية بين الأزرار
                runSpacing: 8.0, // المسافة الرأسية بين الصفوف
                children: _categories.map((category) => _CategoryButton(category: category)).toList(),
              ),
              const SizedBox(height: 24.0),

              // عنوان قسم الكلمات المحظورة
              const Text(
                'Block Words',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 16.0),

              // عرض الكلمات المحظورة حاليًا
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(_blockWords.length, (index) {
                  return _BlockedWordChip(
                    word: _blockWords[index],
                    onRemove: () => _removeBlockWord(index),
                  );
                }),
              ),
              const SizedBox(height: 24.0),

              // عنوان حقل الإدخال
              const Text(
                'Block Words', // يمكنك تغيير هذا العنوان إذا كنت تقصد شيئًا آخر غير تكراره
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 16.0),

              // حقل إدخال الكلمات المحظورة
              TextField(
                controller: _badWordsController,
                decoration: InputDecoration(
                  hintText: 'enter bad words',
                  hintStyle: TextStyle(color: AppColors.blue.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: AppColors.blue.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: AppColors.yellow, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: AppColors.blue),
                    onPressed: _addBlockWord, // إضافة الكلمة عند الضغط على أيقونة الإضافة
                  ),
                ),
                onSubmitted: (_) => _addBlockWord(), // إضافة الكلمة عند الضغط على Enter
              ),
              const SizedBox(height: 24.0),

              // عنوان قسم التاريخ
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 16.0),

              // قائمة سجل التاريخ
              ListView.builder(
                shrinkWrap: true, // مهم لجعل ListView يعمل داخل SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // لمنع ListView من التمرير الخاص به
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.time} // ${item.date}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          item.content,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                          ),
                          textDirection: TextDirection.rtl, // لضمان ظهور النص العربي بشكل صحيح
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget مساعد لأزرار الفئات
class _CategoryButton extends StatelessWidget {
  final String category;

  const _CategoryButton({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.yellowLight,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.yellow),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl, // لضمان ظهور النص العربي بشكل صحيح
      ),
    );
  }
}

// Widget مساعد للكلمات المحظورة
class _BlockedWordChip extends StatelessWidget {
  final String word;
  final VoidCallback onRemove;

  const _BlockedWordChip({required this.word, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.yellowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.yellow),
      ),
      label: Text(
        word,
        style: const TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl, // لضمان ظهور النص العربي بشكل صحيح
      ),
      deleteIcon: const Icon(
        Icons.remove_circle_outline,
        color: Colors.grey,
        size: 18,
      ),
      onDeleted: onRemove,
    );
  }
}