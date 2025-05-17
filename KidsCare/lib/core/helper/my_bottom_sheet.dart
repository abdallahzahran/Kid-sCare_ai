import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

void MyBottomSheet({
  required BuildContext context,
  required Widget child,
  required double height,
}) {
  showModalBottomSheet(
    backgroundColor: AppColors.blue,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (_) => Container(
      padding: const EdgeInsets.all(16),
      height: height,
      child: child,
    ),
  );
}
