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

final authenticatedSessionProvider = Provider<Session?>((ref) {
  final authState = ref.watch(authControllerProvider);
  if (authState.status != AuthStatus.authenticated) {
    return null;
  }

  return authState.session;
});

final sessionScopeKeyProvider = Provider<String?>((ref) {
  final session = ref.watch(authenticatedSessionProvider);
  if (session == null) {
    return null;
  }

  return '${session.tenantId}:${session.userId}:${session.accessToken}';
});

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
    return AuthState(status: AuthStatus.unauthenticated, error: error);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository authRepository,
    Session? initialSession,
    Future<void> Function()? resetSessionScope,
  }) : _authRepository = authRepository,
       _resetSessionScope = resetSessionScope ?? _noop,
       _streamController = StreamController<AuthState>.broadcast(),
       super(
         initialSession == null
             ? AuthState.unauthenticated()
             : AuthState.authenticated(initialSession),
       ) {
    _streamController.add(state);
  }

  final AuthRepository _authRepository;
  final Future<void> Function() _resetSessionScope;
  final StreamController<AuthState> _streamController;
  Future<void>? _pendingSessionInvalidation;
  Future<void>? _pendingSubscriptionUpdate;

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
      await _resetSessionScope();
      state = AuthState.authenticated(session);
    } on AppException catch (error) {
      state = AuthState.unauthenticated(error);
    } catch (_) {
      state = AuthState.unauthenticated(
        const AppException(code: 'UNKNOWN_ERROR', message: ''),
      );
    }
  }

  Future<void> signOut() async {
    await _performLogout();
  }

  Future<Session?> refreshSession() async {
    final currentSession = state.session;
    if (currentSession == null) {
      return null;
    }

    final refreshedSession = await _authRepository.refreshSession(
      currentSession: currentSession,
    );
    state = AuthState.authenticated(refreshedSession);
    return refreshedSession;
  }

  Future<void> handleSubscriptionExpired([AppException? exception]) {
    final currentSession = state.session;
    if (currentSession == null) {
      return Future.value();
    }

    if (_pendingSubscriptionUpdate == null) {
      final completer = Completer<void>();
      _pendingSubscriptionUpdate = completer.future;
      () async {
        try {
          final updatedSession = currentSession.copyWith(
            subscriptionStatus: 'EXPIRED',
          );
          await _authRepository.saveSession(updatedSession);
          state = AuthState.authenticated(updatedSession);
          completer.complete();
        } catch (error, stackTrace) {
          completer.completeError(error, stackTrace);
        } finally {
          if (identical(_pendingSubscriptionUpdate, completer.future)) {
            _pendingSubscriptionUpdate = null;
          }
        }
      }();
    }

    return _pendingSubscriptionUpdate!;
  }

  Future<void> handleSessionInvalidation(AppException exception) {
    if (state.status == AuthStatus.unauthenticated && state.session == null) {
      return Future.value();
    }

    if (_pendingSessionInvalidation == null) {
      final completer = Completer<void>();
      _pendingSessionInvalidation = completer.future;
      () async {
        try {
          await _performLogout(exception: exception);
          completer.complete();
        } catch (error, stackTrace) {
          completer.completeError(error, stackTrace);
        } finally {
          if (identical(_pendingSessionInvalidation, completer.future)) {
            _pendingSessionInvalidation = null;
          }
        }
      }();
    }

    return _pendingSessionInvalidation!;
  }

  Future<void> handleUnauthorized(AppException exception) {
    return handleSessionInvalidation(exception);
  }

  Future<void> _performLogout({AppException? exception}) async {
    state = AuthState.unauthenticated(exception);
    try {
      await _authRepository.logout();
    } finally {
      await _resetSessionScope();
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

Future<void> _noop() async {}
