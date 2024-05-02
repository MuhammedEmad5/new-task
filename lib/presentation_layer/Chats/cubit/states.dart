import 'package:dash_chat_2/dash_chat_2.dart';

abstract class ChatScreenStates{}

class ChatScreenInitialState extends ChatScreenStates{}

class GetUserDataLoadingState extends ChatScreenStates{}
class GetUserDataSuccessState extends ChatScreenStates{}
class GetUserDataErrorState extends ChatScreenStates{
  final String error;

  GetUserDataErrorState(this.error);
}

class SendMessageLoadingState extends ChatScreenStates{}
class SendMessageSuccessState extends ChatScreenStates{}
class SendMessageErrorState extends ChatScreenStates{}


class GetMessageLoadingState extends ChatScreenStates{}
class GetMessageSuccessState extends ChatScreenStates{
  final List<ChatMessage> homeChat;

  GetMessageSuccessState(this.homeChat);
}
class GetMessageErrorState extends ChatScreenStates{
  final String error;

  GetMessageErrorState(this.error);
}

