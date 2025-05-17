import 'kid_state.dart';
import '../repo/kid_repo.dart';
import '../models/kid_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KidCubit extends Cubit<KidState> {
  final KidRepo repo;
  KidCubit(this.repo) : super(KidInitial());

  Future<void> fetchKids() async {
    emit(KidLoading());
    try {
      final kids = await repo.getKids();
      emit(KidLoaded(kids));
    } catch (e) {
      emit(KidError(e.toString()));
    }
  }

  Future<void> addKid(KidModel data) async {
    emit(KidLoading());
    try {
      final kids = await repo.addKid(data);
      emit(KidLoaded(kids));
    } catch (e) {
      emit(KidError(e.toString()));
    }
  }

  Future<void> updateKid(KidModel data) async {
    emit(KidLoading());
    try {
      final kids = await repo.updateKid(data);
      emit(KidLoaded(kids));
    } catch (e) {
      emit(KidError(e.toString()));
    }
  }

  Future<void> deleteKid(String id) async {
    emit(KidLoading());
    try {
      final kids = await repo.deleteKid(id);
      emit(KidLoaded(kids));
    } catch (e) {
      emit(KidError(e.toString()));
    }
  }
} 