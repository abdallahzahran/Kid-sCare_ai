import 'package:flutter/cupertino.dart';

abstract class AppConstants {
  static SizedBox sizedBoxHeight(BuildContext context, double fraction) =>
      SizedBox(height: MediaQuery.of(context).size.height * fraction);

  static SizedBox sizedBoxWidth(BuildContext context, double fraction) =>
      SizedBox(width: MediaQuery.of(context).size.width * fraction);
}
