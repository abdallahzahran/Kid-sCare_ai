import 'package:flutter/material.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/helper/my_validator.dart';
import 'package:kidscare/core/helper/my_responsive.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

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
                    backgroundImage: AssetImage('assets/images/profile.png'), // Replace with your asset
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
                        onPressed: () {},
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
                                // TODO: Save logic
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
                            onPressed: () => Navigator.pop(context),
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