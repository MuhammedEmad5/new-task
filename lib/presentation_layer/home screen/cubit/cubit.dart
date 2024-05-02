import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/application_layer/app_strings.dart';
import 'package:new_task/data_layer/models/post_question_model.dart';
import 'package:new_task/presentation_layer/home%20screen/cubit/states.dart';



class HomeScreenCubit extends Cubit<HomeScreenStates> {

  HomeScreenCubit() : super(HomeScreenInitialState());

  static HomeScreenCubit get(context) => BlocProvider.of(context);


  Future<void> addPostQuestion({
    required String questionTitle,
  }) async {
    emit(AddPostQuestionToFireBaseLoadingState());

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('QuestionPosts')
          .add({'questionTitle': questionTitle});

      String postUid = docRef.id;

      PostQuestionModel model = PostQuestionModel(
        questionTitle: questionTitle,
        wantedUsers: [],
        postIUid: postUid,
        postOpened: []
      );

      await FirebaseFirestore.instance
          .collection('QuestionPosts')
          .doc(postUid)
          .set(model.toMap());

      emit(AddPostQuestionToFireBaseSuccessState());
      getPostQuestion();
    } catch (error) {
      emit(AddPostQuestionToFireBaseErrorState(error.toString()));
    }
  }

  List<PostQuestionModel>allPostsQuestion=[];
  Future<void>getPostQuestion()async {
    emit(GetPostQuestionToFireBaseLoadingState());
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot=await FirebaseFirestore.instance
          .collection('QuestionPosts')
          .get();
      allPostsQuestion.clear();
      for (var element in snapshot.docs) {
        allPostsQuestion.add(PostQuestionModel.fromJson(element.data()));
      }
      emit(GetPostQuestionToFireBaseSuccessState());
    }catch(error){
      emit(GetPostQuestionToFireBaseErrorState(error.toString()));
    }
  }

  bool isMyUidInPostOpened(index) {
    return allPostsQuestion[index].postOpened!.contains(AppStrings.uId);
  }

  Future<void> likeAndDisLike({
    required String postUid,
  }) async {
    emit(LikeAndDisLikeLoadingState());
    try {
      DocumentReference postRef = FirebaseFirestore.instance
          .collection('QuestionPosts')
          .doc(postUid);

      // Get the current wantedUsers list from Firestore
      DocumentSnapshot postSnapshot = await postRef.get();
      List<String> currentWantedUsers =
      List<String>.from(postSnapshot.get('wantedUsers') ?? []);

      // Check if the user ID is already in the list
      bool alreadyLiked = currentWantedUsers.contains(AppStrings.uId);

      // Update the wantedUsers list based on whether the user ID is already present
      if (alreadyLiked) {
        currentWantedUsers.remove(AppStrings.uId); // Remove if already liked
      } else {
        currentWantedUsers.add(AppStrings.uId!); // Add if not already liked
      }

      // Update the wantedUsers field in Firestore
      await postRef.update({'wantedUsers': currentWantedUsers});

      emit(LikeAndDisLikeSuccessState());
      getPostQuestion();
      getLikedPostQuestions();
    } catch (error) {
      emit(LikeAndDisLikeErrorState(error.toString()));
    }
  }

  List<Map<String, dynamic>> likedPosts=[];
  void getLikedPostQuestions() async {
    emit(GetLikedLoadingState());
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('QuestionPosts')
          .where('wantedUsers', arrayContains: AppStrings.uId)
          .get();

      likedPosts.clear();
      for (var element in snapshot.docs) {
        String postUid = element.id;
        likedPosts.add({'postUid': postUid, 'liked': true});
      }
      emit(GetLikedSuccessState());
    } catch (error) {
      emit(GetLikedErrorState(error.toString()));
    }
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

  Future<void> reduceMyCoins(postUId) async {
    emit(ReduceMyCoinLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(AppStrings.uId)
          .update({
        'myCoins': myCoins! - 10,
      });

      await FirebaseFirestore.instance
          .collection('QuestionPosts')
          .doc(postUId)
          .update({
        'postOpened': FieldValue.arrayUnion([AppStrings.uId]),
      });

      //emit(ReduceMyCoinSuccessState());
      getMyCoins();
      getPostQuestion();
    } catch (error) {
      emit(ReduceMyCoinErrorState());
    }
  }

}
