import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/services/kids_service.dart';

class KidsInfoView extends StatefulWidget {
  const KidsInfoView({super.key});

  @override
  State<KidsInfoView> createState() => _KidsInfoViewState();
}

class _KidsInfoViewState extends State<KidsInfoView> {
  List<Map<String, dynamic>> get kids => KidsService().kids;

  void _showDeleteConfirmation(int index) {
    // Check if trying to delete first kid
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete the first kid. Please add another kid first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Kid'),
        content: const Text('Are you sure you want to delete this kid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                KidsService().removeKid(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kid deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showKidDialog({Map<String, dynamic>? kid, int? index}) {
    final nameController = TextEditingController(text: kid?['name'] ?? '');
    final emailController = TextEditingController(text: kid?['email'] ?? '');
    final ageController = TextEditingController(text: kid?['age'] ?? '');
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kid == null ? 'Add Kid' : 'Edit Kid'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Age is required';
                  final age = int.tryParse(value);
                  if (age == null) return 'Enter a valid age';
                  if (age < 0 || age > 18) return 'Age must be between 0 and 18';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newKid = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'age': ageController.text,
                };
                setState(() {
                  if (kid == null) {
                    KidsService().addKid(newKid);
                  } else if (index != null) {
                    KidsService().updateKid(index, newKid);
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Info'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showKidDialog(),
        shape: CircleBorder(),
        backgroundColor: AppColors.yellow,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kids info', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ...kids.asMap().entries.map((entry) {
              final kid = entry.value;
              final idx = entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(kid['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Age: ${kid['age']}', style: const TextStyle(color: Colors.grey)),
                              Text(kid['email']!, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.grayDark2),
                          onPressed: () => _showKidDialog(kid: kid, index: idx),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(idx),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
} 