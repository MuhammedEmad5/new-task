import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/application_layer/App_colors.dart';
import 'package:new_task/application_layer/my_icons.dart';
import 'package:new_task/presentation_layer/layout/cubit/cubit.dart';
import 'package:new_task/presentation_layer/layout/cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>LayoutCubit(),
      child: BlocBuilder<LayoutCubit,LayoutStates>(
        builder: (BuildContext context, state) {
          LayoutCubit cubit=LayoutCubit.get(context);
          return Scaffold(
            body: cubit.layoutScreens[cubit.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.selectedIndex,
              selectedItemColor: AppColors.secondColor,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(MyIcons.home),label:'Home' ),
                BottomNavigationBarItem(icon: Icon(MyIcons.work),label:'Zoom meeting' ),
                BottomNavigationBarItem(icon: Icon(MyIcons.video),label:'Youtube Videos' ),
              ],
            ),
          );
        },
      ),
    );
  }

}
