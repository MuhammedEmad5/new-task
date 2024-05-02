import 'package:flutter/material.dart';
import 'App_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


ThemeData lightTheme(context) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'kanit',
    scaffoldBackgroundColor: AppColors.firstColor,
    disabledColor: AppColors.firstColor,
    primaryColor: AppColors.secondColor,
    focusColor: AppColors.thirdColor,
    primarySwatch: AppColors.getMaterialColor(AppColors.secondColor),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.firstColor,
      iconTheme: IconThemeData(color: AppColors.thirdColor),
      actionsIconTheme: IconThemeData(color: AppColors.thirdColor),
      titleTextStyle: Theme.of(context).textTheme.headlineSmall
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.black),
      displayMedium: TextStyle(
          fontSize: 22.sp, fontWeight: FontWeight.w500, color: AppColors.black),
      displaySmall: TextStyle(
          fontSize: 20.sp, fontWeight: FontWeight.w400, color: AppColors.black),
      headlineMedium: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      headlineSmall: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      titleLarge: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      bodySmall: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      labelSmall: TextStyle(
          fontSize: 10.sp, fontWeight: FontWeight.w200, color: AppColors.black),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: AppColors.secondColor.withOpacity(0.8),
      iconSize: 30.w,
    ),
  );
}
