import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_task/application_layer/App_colors.dart';
import 'package:new_task/application_layer/app_functions.dart';
import 'package:new_task/data_layer/models/zoom_meeting_model.dart';
import 'package:new_task/presentation_layer/Payment/payment_screen.dart';
import 'package:new_task/presentation_layer/widgets/loading.dart';
import '../../application_layer/app_images.dart';
import '../../application_layer/my_icons.dart';
import '../Chats/chats_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/default_button.dart';
import '../widgets/default_text_form_field.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ZoomMeetingScreen extends StatelessWidget {
  ZoomMeetingScreen({super.key});

  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController topics1Controller = TextEditingController();
  final TextEditingController topics2Controller = TextEditingController();

  final bottomSheetFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ZoomMeetingScreenCubit()
        ..getStudentImage()
        ..getMyCoins()
        ..getZoomMeeting(),
      child: BlocConsumer<ZoomMeetingScreenCubit, ZoomMeetingScreenStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          ZoomMeetingScreenCubit cubit = ZoomMeetingScreenCubit.get(context);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      appBarTitle(context, 'ZoomMeeting'),
                      const Spacer(),
                      cubit.myCoins == null
                          ? const LoadingWidget(
                              size: 40,
                            )
                          : myCoins(context, cubit),
                      appBarProfileButton(context),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  state is GetZoomMeetingToFireBaseLoadingState
                      ? const Center(child: LoadingWidget())
                      : cubit.allZoomMeeting.isEmpty
                          ? emptyList(context)
                          : Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => itemBuilder(
                                    context,
                                    cubit.allZoomMeeting[index],
                                    cubit,
                                    state,
                                    index),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 6.h),
                                itemCount: cubit.allZoomMeeting.length,
                              ),
                            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      floatingActionButton(context, cubit),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget appBarTitle(context, title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .displayMedium!
          .copyWith(color: AppColors.thirdColor, fontWeight: FontWeight.w600),
    );
  }

  Widget appBarProfileButton(context) {
    return IconButton(
        onPressed: () {
          AppFunctions.navigateTo(context, UserProfileScreen());
        },
        icon: const Icon(
          MyIcons.profile,
          size: 30,
        ));
  }

  Widget floatingActionButton(context, ZoomMeetingScreenCubit cubit) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return BlocProvider.value(
              value: cubit,
              child: BlocConsumer<ZoomMeetingScreenCubit, ZoomMeetingScreenStates>(
                listener:
                    (BuildContext context, ZoomMeetingScreenStates state) {},
                builder: (BuildContext context, ZoomMeetingScreenStates state) {
                  ZoomMeetingScreenCubit cubit =
                      ZoomMeetingScreenCubit.get(context);
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: bottomSheetFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              courseNameField(),
                              SizedBox(height: 15.h),
                              topics1Field(),
                              SizedBox(height: 15.h),
                              topics2Field(),
                              SizedBox(height: 15.h),
                              state is AddZoomMeetingToFireBaseLoadingState
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 160.w),
                                      child: const LoadingWidget(),
                                    )
                                  : addButton(context, cubit),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      child: Icon(
        MyIcons.paperUpload,
        color: AppColors.firstColor,
      ),
    );
  }

  Widget courseNameField() {
    return DefaultTextFormField(
      controller: courseNameController,
      inputType: TextInputType.name,
      labelText: 'course name',
      prefixIcon: MyIcons.document,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter course name';
        }
        return null;
      },
    );
  }

  Widget topics1Field() {
    return DefaultTextFormField(
      controller: topics1Controller,
      inputType: TextInputType.name,
      labelText: 'topics 1',
      prefixIcon: Icons.list_rounded,
      validator: (value) {
        if (value.isEmpty) {
          return 'topics 1 can\'t be Empty';
        }
        return null;
      },
    );
  }

  Widget topics2Field() {
    return DefaultTextFormField(
      controller: topics2Controller,
      inputType: TextInputType.name,
      labelText: 'topics 2',
      prefixIcon: Icons.list_rounded,
      validator: (value) {
        if (value.isEmpty) {
          return 'topics 2 can\'t be Empty';
        }
        return null;
      },
    );
  }

  Widget addButton(context, ZoomMeetingScreenCubit cubit) {
    return Padding(
      padding: EdgeInsets.only(left: 160.w),
      child: DefaultButton(
        onPressed: () {
          if (bottomSheetFormKey.currentState!.validate()) {
            cubit.addZoomMeeting(
              courseName: courseNameController.text,
              topics: [topics1Controller.text, topics2Controller.text],
            ).then((value) {
              Navigator.pop(context);
              courseNameController.clear();
              topics1Controller.clear();
              topics2Controller.clear();
            });
          }
        },
        child: Text(
          'Add',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.firstColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget itemBuilder(context, ZoomMeetingModel model,
      ZoomMeetingScreenCubit cubit, state, index) {
    return InkWell(
      onTap: () {
        cubit.isMyUidInPostOpened(index)
            ? AppFunctions.navigateTo(
                context, ChatScreen(uId: model.zoomMeetingUid!, collectionName: 'ZoomMeetings',))
            : cubit.myCoins! < 10
                ? AppFunctions.showSnackBar(
                    context, 'you don\'t have coins please recharge..',
                    error: true)
                : showDialogWidget(context, model.zoomMeetingUid, cubit, state);
      },
      child: Card(
        elevation: 10,
        shadowColor: AppColors.secondColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image(
                  image: NetworkImage(model.studentImage!),
                  height: 120,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width/3,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name : ${model.studentName}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColors.black),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Course : ${model.courseName}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: AppColors.black,fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Topics',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      '- ${model.topics![0]}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.secondColor),
                    ),
                    Text(
                      '- ${model.topics![1]}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.secondColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showDialogWidget(
    context,
    zoomMeetingUid,
    ZoomMeetingScreenCubit cubit,
    state,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return state is ReduceMyCoinLoadingState
            ? const LoadingWidget()
            : AlertDialog(
                title: Text(
                  'Let\'s chat',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: AppColors.thirdColor),
                ),
                content: Text(
                  '10 coins will be deducted',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.secondColor),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      cubit.reduceMyCoins(zoomMeetingUid).then((value) {
                        Navigator.pop(context);
                        AppFunctions.navigateTo(
                            context, ChatScreen(uId: zoomMeetingUid, collectionName: 'ZoomMeetings',));
                      });
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
      },
    );
  }

  Widget emptyList(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(AppAnimation.empty),
            Center(
              child: Text(
                'no zoom meetings yet',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.secondColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myCoins(context, ZoomMeetingScreenCubit cubit) {
    return InkWell(
      onTap: () {
        AppFunctions.navigateTo(
            context,
            PaymentScreen(
              myCoins: cubit.myCoins.toString(),
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            cubit.myCoins.toString(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.thirdColor),
          ),
          const Icon(
            Icons.attach_money,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
