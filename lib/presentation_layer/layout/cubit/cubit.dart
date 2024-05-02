import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/presentation_layer/home%20screen/home_screen.dart';
import 'package:new_task/presentation_layer/layout/cubit/states.dart';
import 'package:new_task/presentation_layer/youtube%20videos/youtube_videos_screen.dart';
import 'package:new_task/presentation_layer/zoom%20meeting/zoom_meeting_screen.dart';


class LayoutCubit extends Cubit<LayoutStates> {

  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);


  List<Widget>layoutScreens=[
    HomeScreen(),
    ZoomMeetingScreen(),
    YoutubeVideosScreen(),
  ];

  List<String>titles=[
    'Home',
    'Zoom meeting',
    'Youtube Videos',
  ];

  int selectedIndex = 0;
  void changeNavBar(int index){
    selectedIndex=index;
    emit(ChangeNavBarState());
  }




}
