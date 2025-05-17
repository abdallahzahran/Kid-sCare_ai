import '../models/kid_model.dart';

abstract class KidState {}

class KidInitial extends KidState {}
class KidLoading extends KidState {}
class KidLoaded extends KidState {
  final List<KidModel> kids;
  KidLoaded(this.kids);
}
class KidError extends KidState {
  final String message;
  KidError(this.message);
} 