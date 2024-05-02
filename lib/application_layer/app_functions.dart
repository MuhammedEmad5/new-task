import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'my_icons.dart';


class AppFunctions {

  static Future<dynamic> navigateTo(context, Widget newScreen) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => newScreen,
        ));
  }

  static Future<dynamic> navigateToAndRemove(context, Widget newScreen) {
    return  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => newScreen),
          (route) => false, // Remove all routes except the new one
    );
  }

  static Widget backButton(context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          MyIcons.arrowLeftCircle,
          size: 32.w,
          shadows: [
            BoxShadow(
              color: Theme.of(context).disabledColor,
              spreadRadius: 4,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ));
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String content,
      {required bool error}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).disabledColor),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

}
