
abstract class HomeScreenStates{}

class HomeScreenInitialState extends HomeScreenStates{}

class AddPostQuestionToFireBaseLoadingState extends HomeScreenStates{}
class AddPostQuestionToFireBaseSuccessState extends HomeScreenStates{}
class AddPostQuestionToFireBaseErrorState extends HomeScreenStates{
  final String error;
  AddPostQuestionToFireBaseErrorState(this.error);
}

class GetPostQuestionToFireBaseLoadingState extends HomeScreenStates{}
class GetPostQuestionToFireBaseSuccessState extends HomeScreenStates{}
class GetPostQuestionToFireBaseErrorState extends HomeScreenStates{
  final String error;
  GetPostQuestionToFireBaseErrorState(this.error);
}


class LikeAndDisLikeLoadingState extends HomeScreenStates{}
class LikeAndDisLikeSuccessState extends HomeScreenStates{}
class LikeAndDisLikeErrorState extends HomeScreenStates{
  final String error;
  LikeAndDisLikeErrorState(this.error);
}

class GetLikedLoadingState extends HomeScreenStates{}
class GetLikedSuccessState extends HomeScreenStates{}
class GetLikedErrorState extends HomeScreenStates{
  final String error;
  GetLikedErrorState(this.error);
}

class GetMyCoinLoadingState extends HomeScreenStates{}
class GetMyCoinSuccessState extends HomeScreenStates{}
class GetMyCoinErrorState extends HomeScreenStates{}

class ReduceMyCoinLoadingState extends HomeScreenStates{}
class ReduceMyCoinSuccessState extends HomeScreenStates{}
class ReduceMyCoinErrorState extends HomeScreenStates{}





























