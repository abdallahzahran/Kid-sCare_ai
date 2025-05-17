import 'package:flutter/material.dart';
import 'package:kidscare/core/helper/my_navigator.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/helper/my_validator.dart';
import 'package:kidscare/core/helper/my_responsive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:kidscare/core/services/kids_service.dart';
import 'package:kidscare/features/auth/views/login_view.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Save the image to the app's documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + pickedFile.name;
      final File savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() {
        _image = savedImage;
      });
      // TODO: Save the path to persistent storage if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MyResponsive.width(context, value: 16);
    final double avatarRadius = MyResponsive.height(context, value: 60);
    final double buttonHeight = MyResponsive.height(context, value: 44);
    final double fieldSpacing = MyResponsive.height(context, value: 32);
    final double buttonSpacing = MyResponsive.height(context, value: 16);
    final double maxFormWidth = MyResponsive.width(context, value: 350);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: MyResponsive.height(context, value: 24)),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: _image != null 
                        ? FileImage(_image!) 
                        : const AssetImage('assets/images/profile.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: fieldSpacing),
              Form(
                key: _formKey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          label: 'Username',
                          controller: nameController,
                          validator: RequiredValidator(),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: fieldSpacing),
                        SizedBox(
                          height: buttonHeight,
                          child: CustomElevatedButton(
                            textButton: 'Apply',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                KidsService().setParentName(nameController.text);
                                if (_image != null) {
                                  KidsService().setParentPhotoPath(_image!.path);
                                }
                                Navigator.pop(context, true); // Indicate update
                              }
                            },
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                            shadowColor: const Color(0xFFFFC107),
                          ),
                        ),
                        SizedBox(height: buttonSpacing),
                        SizedBox(
                          height: buttonHeight,
                          child: CustomElevatedButton(
                            textButton: 'Cancel',
                            onPressed: () => MyNavigator.goTo(screen: LoginView()),
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                            shadowColor: const Color(0xFFFFC107),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: fieldSpacing),
            ],
          ),
        ),
      ),
    );
  }
} 