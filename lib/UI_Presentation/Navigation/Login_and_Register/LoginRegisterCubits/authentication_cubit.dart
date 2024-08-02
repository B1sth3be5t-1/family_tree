import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:family_tree/Repositories/repository_manager.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late RepositoryManager _repository;

  AuthenticationCubit() : super(AuthenticationInitial()) {
    _repository = GetIt.I<RepositoryManager>();
  }

  Future<void> loginUser(String u, String p) async {
    emit(AuthenticationLoadingState());
    try {
      await _repository.authRepo.logInUser(u, p);
      emit(AuthenticationSuccessState());
    } catch (e) {
      print(e);
      //todo error checking
      emit(AuthenticationFailureState(Exception(e.toString())));
    }
  }

  Future<void> registerUser(String u, String p, String fName, String lName,
      String? familyCode) async {
    emit(AuthenticationLoadingState());
    bool isRegistered = false;
    try {
      await _repository.authRepo.registerUser(u, p, fName, lName, familyCode);

      isRegistered = true;
      await _repository.authRepo.logInUser(u, p);

      emit(AuthenticationSuccessState());
    } catch (e) {
      print(e);

      if (e.toString().contains('weak-password')) {
        emit(AuthenticationRegistrationFailurePassState());
      } else if (e.toString().contains('family_not_found')) {
        emit(AuthenticationRegistrationFailureFamilyState());
      } else if (e.toString().contains('email-in-use')) {
        emit(AuthenticationRegistrationFailureEmailState());
      } else if (e.toString().contains('Exception: add-info-error')) {
        emit(AuthenticationFailureState(Exception(e.toString())));
      } else if (!isRegistered) {
        emit(AuthenticationRegistrationFailureState());
      } else {
        emit(AuthenticationFailureState(Exception(e.toString())));
      }
    }
  }
}
