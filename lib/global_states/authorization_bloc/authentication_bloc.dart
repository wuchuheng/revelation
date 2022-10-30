import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/model/user_model/user_model.dart';

import '../../api/cache_service.dart';
import '../../dao/sqlite_dao.dart';
import '../../dao/user_dao/user_dao.dart';

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
          _cacheService.connect(
            userName: user.userName,
            password: user.password,
            imapServerHost: user.host,
            imapServerPort: user.port,
            isImapServerSecure: user.tls,
          );
          emit(const AuthenticationState.authenticated());
        } catch (_) {
          _cacheService.disconnect();
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
    await _cacheService.disconnect();
    emit(const AuthenticationState.unauthenticated());
  }

  /// Automatic login event.
  Future<void> _onAuthenticationAutoLoginRequested(
      AuthenticationAutoLoginRequested event, Emitter<AuthenticationState> emit) async {
    await SQLiteDao.init();
    final UserModel? user = UserDao().has();
    if (user == null) {
      emit(const AuthenticationState.unauthenticated());
      return;
    }
    try {
      await _cacheService.connect(
        userName: user.userName,
        password: user.password,
        imapServerHost: user.host,
        imapServerPort: user.port,
        isImapServerSecure: user.tls,
      );
      emit(const AuthenticationState.authenticated());
    } catch (_) {
      _cacheService.disconnect();
      emit(const AuthenticationState.unauthenticated());
    }
  }

  final CacheService _cacheService;

  AuthenticationBloc({required CacheService cacheService})
      : _cacheService = cacheService,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationAutoLoginRequested>(_onAuthenticationAutoLoginRequested);
  }
}
