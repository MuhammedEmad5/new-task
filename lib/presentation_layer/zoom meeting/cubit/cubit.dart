import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/application_layer/app_strings.dart';
import 'package:new_task/presentation_layer/zoom%20meeting/cubit/states.dart';

import '../../../application_layer/app_images.dart';
import '../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../data_layer/models/user_model.dart';
import '../../../data_layer/models/zoom_meeting_model.dart';



class ZoomMeetingScreenCubit extends Cubit<ZoomMeetingScreenStates> {

  ZoomMeetingScreenCubit() : super(ZoomMeetingScreenInitialState());

  static ZoomMeetingScreenCubit get(context) => BlocProvider.of(context);


  String? studentImage;
  Future<void> getStudentImage() async {
    emit(GetStudentImageLoadingState());
    try {
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(CashHelper.getStringData(key: 'uId'))
          .get();
      final userDataModel = UserDataModel.fromJson(userDataSnapshot.data()!);
      if(userDataModel.userImage!=null){
        studentImage = userDataModel.userImage;
      }
      emit(GetStudentImageSuccessState());
    } catch (error) {
      emit(GetStudentImageErrorState());
    }
  }

  String getRandomString() {
    final random = Random();
    final randomIndex = random.nextInt(AppImages.zoomMeetingImages.length);
    return AppImages.zoomMeetingImages[randomIndex];
  }

  Future<void> addZoomMeeting({
    required String courseName,
    required List<String> topics,
  }) async {
    emit(AddZoomMeetingToFireBaseLoadingState());

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('ZoomMeetings')
          .add({'courseName': courseName});

      String zoomMeetingUid = docRef.id;

      ZoomMeetingModel model = ZoomMeetingModel(
        courseName: courseName,
        zoomMeetingUid: zoomMeetingUid,
        studentImage: studentImage??getRandomString(),
        topics: topics,
        studentName: AppStrings.userName,
          zoomMeetingOpened: []
      );

      await FirebaseFirestore.instance
          .collection('ZoomMeetings')
          .doc(zoomMeetingUid)
          .set(model.toMap());

      emit(AddZoomMeetingToFireBaseSuccessState());
      getZoomMeeting();
    } catch (error) {
      emit(AddZoomMeetingToFireBaseErrorState(error.toString()));
    }
  }

  List<ZoomMeetingModel>allZoomMeeting=[];
  Future<void>getZoomMeeting()async {
    emit(GetZoomMeetingToFireBaseLoadingState());
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot=await FirebaseFirestore.instance
          .collection('ZoomMeetings')
          .get();
      allZoomMeeting.clear();
      for (var element in snapshot.docs) {
        allZoomMeeting.add(ZoomMeetingModel.fromJson(element.data()));
      }
      emit(GetZoomMeetingToFireBaseSuccessState());
    }catch(error){
      emit(GetZoomMeetingToFireBaseErrorState(error.toString()));
    }
  }

  bool isMyUidInPostOpened(index) {
    return allZoomMeeting[index].zoomMeetingOpened!.contains(AppStrings.uId);
  }

  int? myCoins;
  Future<void>getMyCoins()async {
    emit(GetMyCoinLoadingState());
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot=await FirebaseFirestore.instance
          .collection('Users')
          .doc(AppStrings.uId)
          .get();
      myCoins=snapshot.data()!['myCoins'];
      emit(GetMyCoinSuccessState());
    }catch(error){
      emit(GetMyCoinErrorState());
    }
  }

  Future<void> reduceMyCoins(zoomMeetingUid) async {
    emit(ReduceMyCoinLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(AppStrings.uId)
          .update({
        'myCoins': myCoins! - 10,
      });

      await FirebaseFirestore.instance
          .collection('ZoomMeetings')
          .doc(zoomMeetingUid)
          .update({
        'zoomMeetingOpened': FieldValue.arrayUnion([AppStrings.uId]),
      });

      emit(ReduceMyCoinSuccessState());
      getMyCoins();
      getZoomMeeting();
    } catch (error) {
      emit(ReduceMyCoinErrorState());
    }
  }

}
