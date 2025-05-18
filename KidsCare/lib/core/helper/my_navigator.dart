import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class MyNavigator {
  static goTo({
    required Widget screen,
    bool isReplace = false,
    Transition transition = Transition.rightToLeftWithFade,
    Duration? duration,
  }) {
    final transitionDuration = duration ?? const Duration(milliseconds: 300);
    
    if (isReplace) {
      Get.offAll(
        () => screen,
        transition: transition,
        duration: transitionDuration,
      );
    } else {
      Get.to(
        () => screen,
        transition: transition,
        duration: transitionDuration,
      );
    }
  }
}