import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/presentation_layer/Chats/cubit/states.dart';
import '../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../data_layer/models/user_model.dart';

class ChatScreenCubit extends Cubit<ChatScreenStates> {
  ChatScreenCubit() : super(ChatScreenInitialState());

  static ChatScreenCubit get(context) => BlocProvider.of(context);

  List<ChatMessage> messages = [];

  UserDataModel? userDataModel;

  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(CashHelper.getStringData(key: 'uId'))
          .get();
      userDataModel = UserDataModel.fromJson(snapshot.data()!);
      emit(GetUserDataSuccessState());
    } catch (error) {
      emit(GetUserDataErrorState(error.toString()));
    }
  }

  void sendMessage({
    required String uId,
    required String message,
    required ChatUser user,
    required String collectionName,
  }) async {
    emit(SendMessageLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uId)
          .collection('messages')
          .add(
        ChatMessage(
          user: user,
          text: message,
          createdAt: DateTime.now(),
        ).toJson(),
      );
      emit(SendMessageSuccessState());
    } catch (error) {
      emit(SendMessageErrorState());
    }
  }

  void streamMessages({
    required String uId,
    required String collectionName,
  }) {
    // Cancel existing subscription if any
    _messageStreamSubscription?.cancel();

    _messageStreamSubscription = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(uId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages = snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data()))
          .toList();
      emit(GetMessageSuccessState(messages));
    }, onError: (error) {
      emit(GetMessageErrorState(error.toString()));
    });
  }

  // Cancel subscription when disposing the cubit
  StreamSubscription<QuerySnapshot>? _messageStreamSubscription;

  @override
  Future<void> close() {
    _messageStreamSubscription?.cancel(); // Cancel subscription on close
    return super.close();
  }
}
