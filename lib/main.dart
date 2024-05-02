import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_task/presentation_layer/layout/layout_screen.dart';
import 'package:new_task/presentation_layer/login%20screen/login_screen.dart';
import 'application_layer/app_strings.dart';
import 'application_layer/bloc_observer.dart';
import 'application_layer/shared_preferences/shared_preferences.dart';
import 'application_layer/themes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CashHelper.init();
  Bloc.observer = MyBlocObserver();


  Widget? widget;
  AppStrings.uId = CashHelper.getStringData(key: 'uId');
  AppStrings.userName = CashHelper.getStringData(key: 'userName');

  if (AppStrings.uId!=null) {
    widget = const LayoutScreen();
  }
  else {
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startWidget});
  final Widget? startWidget;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme(context),
          home: startWidget,
        );
      },
    );
  }
}
