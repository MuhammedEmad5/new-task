import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/presentation_layer/register%20screen/cubit/states.dart';
import '../../../data_layer/models/user_model.dart';

class RegisterScreenCubit extends Cubit<RegisterScreenStates> {
  RegisterScreenCubit() : super(RegisterScreenInitialState());

  static RegisterScreenCubit get(context) => BlocProvider.of(context);

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChangedState());
  }

  String generateId() {
    int min = 10000000; // Minimum 8-digit number
    int max = 99999999; // Maximum 8-digit number
    int id = min + Random().nextInt(max - min);
    return id.toString();
  }

  Future<void> createNewAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(RegisterEmailLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await saveDataInFireBase(
        email: email,
        name: name,
        phone: phone,
        password: password,
        uId: userCredential.user!.uid,
      );
    } catch (error) {
      emit(RegisterEmailErrorState(error.toString()));
    }
  }

  Future<void> saveDataInFireBase({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String uId,
  }) async {
    UserDataModel model = UserDataModel(
      email: email,
      password: password,
      phone: phone,
      uId: uId,
      name: name,
      id: generateId(),
      myCoins: 200,
    );
    try {
      await FirebaseFirestore.instance.collection('Users').doc(uId).set(model.toMap());
      emit(SaveUserDataSuccessState(uId));
    } catch (error) {
      emit(SaveUserDataErrorState(error.toString()));
    }
  }
}
