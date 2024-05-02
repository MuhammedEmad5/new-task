import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/application_layer/app_strings.dart';
import '../../../application_layer/App_colors.dart';
import '../../application_layer/my_icons.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatScreen extends StatelessWidget {
  final String uId;
  final String collectionName;

  const ChatScreen({super.key, required this.uId, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ChatScreenCubit()..getUserData()..streamMessages(uId:uId, collectionName: collectionName),
      child: BlocConsumer<ChatScreenCubit, ChatScreenStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          ChatScreenCubit cubit = ChatScreenCubit.get(context);
          String firstName = '';
          String lastName = '';

          if (cubit.userDataModel != null && cubit.userDataModel!.name != null) {
            List<String> nameParts = cubit.userDataModel!.name!.split(' ');
            firstName = nameParts.isNotEmpty ? nameParts[0] : '';
            lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          }


          final ChatUser currentUser = ChatUser(
            id: AppStrings.uId!,
            firstName: firstName,
            lastName: lastName,
          );

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.thirdColor,
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  MyIcons.arrowLeftCircle,
                  color: AppColors.firstColor,
                  size: 30,
                ),
              ),
              title: Text('Chat',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.firstColor,
                      fontWeight: FontWeight.w500)),
            ),
            body: DashChat(
              currentUser: currentUser,
              messageOptions: MessageOptions(
                currentUserContainerColor: AppColors.secondColor,
                containerColor: AppColors.thirdColor,
                textColor: Colors.white,
                showOtherUsersAvatar: true,
                showOtherUsersName: true,
                showTime: true,
              ),
              onSend: (ChatMessage m) {
                cubit.sendMessage(
                    uId: uId, message: m.text, user: currentUser,
                    collectionName: collectionName);
              },
              messages: cubit.messages,
            ),
          );
        },
      ),
    );
  }


}
