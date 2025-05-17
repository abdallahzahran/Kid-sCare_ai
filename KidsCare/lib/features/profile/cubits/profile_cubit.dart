import 'profile_state.dart';
import '../repo/profile_repo.dart';
import '../models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;
  ProfileCubit(this.repo) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await repo.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(ProfileModel data) async {
    emit(ProfileLoading());
    try {
      final updated = await repo.updateProfile(data);
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
} 