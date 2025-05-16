import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeCubit extends Cubit<Map<String, TimeOfDay>> {
  TimeCubit()
      : super({
    'startTime': const TimeOfDay(hour: 9, minute: 0),
    'endTime': const TimeOfDay(hour: 17, minute: 0),
  });

  void updateStartTime(TimeOfDay time) {
    emit({
      'startTime': time,
      'endTime': state['endTime']!,
    });
  }

  void updateEndTime(TimeOfDay time) {
    emit({
      'startTime': state['startTime']!,
      'endTime': time,
    });
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // Example: 09:00 AM
  }
}
