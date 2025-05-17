import '../models/profile_model.dart';

class ProfileRepo {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(Duration(seconds: 1));
    return ProfileModel(
      name: 'Test User',
      email: 'test@example.com',
      phone: '+20123456789',
      image: null,
    );
  }

  Future<ProfileModel> updateProfile(ProfileModel data) async {
    await Future.delayed(Duration(seconds: 1));
    return data;
  }
} 