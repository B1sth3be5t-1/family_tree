part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//-----------------Auth loading, success, and failure states -----------------------
//Signifies that auth is loading
class AuthenticationLoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//signifies that the user is now logged in
class AuthenticationSuccessState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//signifies that there was an error with login
class AuthenticationFailureState extends AuthenticationState {
  final Exception e;

  AuthenticationFailureState(this.e);

  @override
  List<Object> get props => [e];
}

//signifies that there was an error with registration
class AuthenticationRegistrationFailureState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//signifies that the family code was wrong
class AuthenticationRegistrationFailureFamilyState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//signifies that the email was already in use
class AuthenticationRegistrationFailureEmailState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

//signifies that the password is not strong enough
class AuthenticationRegistrationFailurePassState extends AuthenticationState {
  @override
  List<Object> get props => [];
}
//------------------------------------------------------------------------------
