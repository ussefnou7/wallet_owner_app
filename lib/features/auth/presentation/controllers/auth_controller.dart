import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

final initialSessionProvider = Provider<Session?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final initialSession = ref.watch(initialSessionProvider);
    return AuthController(
      authRepository: authRepository,
      initialSession: initialSession,
    );
  },
);

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.session, this.error});

  final AuthStatus status;
  final Session? session;
  final AppException? error;

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(Session session) {
    return AuthState(status: AuthStatus.authenticated, session: session);
  }

  factory AuthState.unauthenticated([AppException? error]) {
    return AuthState(
      status: AuthStatus.unauthenticated,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository authRepository,
    Session? initialSession,
  }) : _authRepository = authRepository,
       _streamController = StreamController<AuthState>.broadcast(),
       super(
         initialSession == null
             ? AuthState.unauthenticated()
             : AuthState.authenticated(initialSession),
       ) {
    _streamController.add(state);
  }

  final AuthRepository _authRepository;
  final StreamController<AuthState> _streamController;

  @override
  Stream<AuthState> get stream => _streamController.stream;

  @override
  set state(AuthState value) {
    super.state = value;
    if (!_streamController.isClosed) {
      _streamController.add(value);
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final session = await _authRepository.login(
        username: username,
        password: password,
      );
      state = AuthState.authenticated(session);
    } on AppException catch (error) {
      state = AuthState.unauthenticated(error);
    } catch (_) {
      state = AuthState.unauthenticated(
        const AppException(
          code: 'UNKNOWN_ERROR',
          message: '',
        ),
      );
    }
  }

  Future<void> signOut() async {
    await _authRepository.logout();
    state = AuthState.unauthenticated();
  }

  Future<void> handleUnauthorized(AppException exception) async {
    await _authRepository.logout();
    state = AuthState.unauthenticated(exception);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
