import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/model/user_model/user_model.dart';

import '../../service/cache_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unknown:
        break;
      case AuthenticationStatus.authenticated:
        final user = event.user;
        try {
          await CacheService.connect(
            userName: user.userName,
            password: user.password,
            imapServerHost: user.host,
            imapServerPort: user.port,
            isImapServerSecure: user.tls,
          );
          emit(const AuthenticationState.authenticated());
        } catch (_) {
          rethrow;
        }
        break;
      case AuthenticationStatus.unauthenticated:
        emit(const AuthenticationState.unauthenticated());
        break;
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) async {
    await CacheService.disconnect();
    emit(const AuthenticationState.unauthenticated());
  }

  AuthenticationBloc() : super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
  }
}
