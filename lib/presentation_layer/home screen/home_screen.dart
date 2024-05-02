import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_task/application_layer/App_colors.dart';
import 'package:new_task/application_layer/app_functions.dart';
import 'package:new_task/data_layer/models/post_question_model.dart';
import 'package:new_task/presentation_layer/Payment/payment_screen.dart';
import 'package:new_task/presentation_layer/home%20screen/cubit/cubit.dart';
import 'package:new_task/presentation_layer/home%20screen/cubit/states.dart';
import 'package:new_task/presentation_layer/widgets/default_button.dart';
import 'package:new_task/presentation_layer/widgets/default_text_form_field.dart';
import 'package:new_task/presentation_layer/widgets/loading.dart';
import '../../application_layer/app_images.dart';
import '../../application_layer/my_icons.dart';
import '../Chats/chats_screen.dart';
import '../profile/profile_screen.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeScreenCubit()
        ..getMyCoins()
        ..getPostQuestion()
        ..getLikedPostQuestions(),
      child: BlocConsumer<HomeScreenCubit, HomeScreenStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          HomeScreenCubit cubit = HomeScreenCubit.get(context);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      appBarTitle(context, 'Home'),
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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DefaultTextFormField(
                          controller: postController,
                          inputType: TextInputType.multiline,
                          labelText: 'question',
                          prefixIcon: Icons.question_mark,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'question can\'t be Empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: state is AddPostQuestionToFireBaseLoadingState
                            ? const LoadingWidget()
                            : DefaultButton(
                                onPressed: () {
                                  cubit
                                      .addPostQuestion(
                                          questionTitle: postController.text)
                                      .then((value) {
                                    postController.clear();
                                  });
                                },
                                child: Text(
                                  'Post',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: AppColors.firstColor),
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  state is GetPostQuestionToFireBaseLoadingState
                      ? const Center(child: LoadingWidget())
                      : cubit.allPostsQuestion.isEmpty
                          ? emptyList(context)
                          : Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => itemBuilder(
                                    context,
                                    cubit.allPostsQuestion[index],
                                    cubit,
                                    state,
                                    index),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 6.h),
                                itemCount: cubit.allPostsQuestion.length,
                              ),
                            )
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

  Widget itemBuilder(
      context, PostQuestionModel model, HomeScreenCubit cubit, state, index) {
    return InkWell(
      onTap: () {
        cubit.isMyUidInPostOpened(index)
            ? AppFunctions.navigateTo(
                context, ChatScreen(uId: model.postIUid!, collectionName: 'QuestionPosts',))
            : cubit.myCoins! < 10
                ? AppFunctions.showSnackBar(
                    context, 'you don\'t have coins please recharge..',
                    error: true)
                : showDialogWidget(context, model.postIUid, cubit, state);
      },
      child: Card(
        elevation: 10,
        shadowColor: AppColors.secondColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  model.questionTitle!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.thirdColor),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 3,
                child: state is LikeAndDisLikeLoadingState
                    ? const Center(child: LoadingWidget())
                    : InkWell(
                        onTap: () {
                          cubit.likeAndDisLike(postUid: model.postIUid!);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 6.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    cubit.likedPosts.any((post) =>
                                            post['postUid'] == model.postIUid &&
                                            post['liked'])
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: cubit.likedPosts.any((post) =>
                                            post['postUid'] == model.postIUid &&
                                            post['liked'])
                                        ? Colors.pink
                                        : null,
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      'wanted(${model.wantedUsers!.length})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: AppColors.thirdColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool?> showDialogWidget(
    context,
    postUid,
    HomeScreenCubit cubit,
    state,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return state is ReduceMyCoinLoadingState || state is GetMyCoinLoadingState
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
                      cubit.reduceMyCoins(postUid).then((value) {
                        Navigator.pop(context);
                        AppFunctions.navigateTo(
                            context, ChatScreen(uId:postUid, collectionName: 'QuestionPosts',));
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
                'no posted questions yet',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.secondColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myCoins(context, HomeScreenCubit cubit) {
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
