
abstract class ZoomMeetingScreenStates{}

class ZoomMeetingScreenInitialState extends ZoomMeetingScreenStates{}

class GetStudentImageLoadingState extends ZoomMeetingScreenStates{}
class GetStudentImageSuccessState extends ZoomMeetingScreenStates{}
class GetStudentImageErrorState extends ZoomMeetingScreenStates{}

class AddZoomMeetingToFireBaseLoadingState extends ZoomMeetingScreenStates{}
class AddZoomMeetingToFireBaseSuccessState extends ZoomMeetingScreenStates{}
class AddZoomMeetingToFireBaseErrorState extends ZoomMeetingScreenStates{
  final String error;
  AddZoomMeetingToFireBaseErrorState(this.error);
}

class GetZoomMeetingToFireBaseLoadingState extends ZoomMeetingScreenStates{}
class GetZoomMeetingToFireBaseSuccessState extends ZoomMeetingScreenStates{}
class GetZoomMeetingToFireBaseErrorState extends ZoomMeetingScreenStates{
  final String error;
  GetZoomMeetingToFireBaseErrorState(this.error);
}

class GetMyCoinLoadingState extends ZoomMeetingScreenStates{}
class GetMyCoinSuccessState extends ZoomMeetingScreenStates{}
class GetMyCoinErrorState extends ZoomMeetingScreenStates{}

class ReduceMyCoinLoadingState extends ZoomMeetingScreenStates{}
class ReduceMyCoinSuccessState extends ZoomMeetingScreenStates{}
class ReduceMyCoinErrorState extends ZoomMeetingScreenStates{}





























