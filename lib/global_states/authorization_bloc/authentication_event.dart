part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  final AuthenticationStatus status;
  final UserModel user;

  const AuthenticationStatusChanged(this.status, this.user);

  @override
  List<Object> get props => [status, user];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

/// Automatic login events.
class AuthenticationAutoLoginRequested extends AuthenticationEvent {}
