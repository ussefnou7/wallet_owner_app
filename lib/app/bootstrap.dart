import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception_mapper.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/dio_provider.dart';
import '../core/storage/app_secure_storage.dart';
import '../features/auth/data/repositories/app_auth_repository.dart';
import '../features/auth/data/services/auth_remote_data_source.dart';
import '../features/auth/data/services/session_local_data_source.dart';
import '../features/auth/domain/entities/session.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/branches/data/repositories/mock_branches_repository.dart';
import '../features/branches/domain/repositories/branches_repository.dart';
import '../features/plans/data/repositories/mock_plans_repository.dart';
import '../features/plans/domain/repositories/plans_repository.dart';
import '../features/settings/data/repositories/mock_renewal_requests_repository.dart';
import '../features/settings/domain/repositories/renewal_requests_repository.dart';
import '../features/transactions/data/repositories/mock_transactions_repository.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/users/data/repositories/mock_users_repository.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/wallets/data/repositories/mock_wallets_repository.dart';
import '../features/wallets/domain/repositories/wallets_repository.dart';

Future<ProviderContainer> bootstrap() async {
  final config = AppConfig.fromEnv();
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = AppSecureStorage();
  final localDataSource = SessionLocalDataSource(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
  final authInterceptor = AuthInterceptor(
    readAccessToken: localDataSource.readAccessToken,
  );
  final dio = createDio(config: config, authInterceptor: authInterceptor);
  final apiClient = DioApiClient(dio);
  const apiExceptionMapper = ApiExceptionMapper();
  final authRemoteDataSource = DioAuthRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: apiExceptionMapper,
  );
  final authRepository = AppAuthRepository(
    sessionLocalDataSource: localDataSource,
    remoteDataSource: authRemoteDataSource,
  );
  final walletsRepository = MockWalletsRepository();
  final transactionsRepository = MockTransactionsRepository();
  final usersRepository = MockUsersRepository();
  final branchesRepository = MockBranchesRepository();
  final plansRepository = MockPlansRepository();
  final renewalRequestsRepository = MockRenewalRequestsRepository();
  Session? initialSession;
  try {
    initialSession = await authRepository.getCurrentSession();
  } catch (_) {
    initialSession = null;
  }

  return ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      secureStorageProvider.overrideWithValue(secureStorage),
      sessionLocalDataSourceProvider.overrideWithValue(localDataSource),
      authInterceptorProvider.overrideWithValue(authInterceptor),
      dioProvider.overrideWithValue(dio),
      apiClientProvider.overrideWithValue(apiClient),
      apiExceptionMapperProvider.overrideWithValue(apiExceptionMapper),
      authRemoteDataSourceProvider.overrideWithValue(authRemoteDataSource),
      authRepositoryProvider.overrideWithValue(authRepository),
      walletsRepositoryProvider.overrideWithValue(walletsRepository),
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      usersRepositoryProvider.overrideWithValue(usersRepository),
      branchesRepositoryProvider.overrideWithValue(branchesRepository),
      plansRepositoryProvider.overrideWithValue(plansRepository),
      renewalRequestsRepositoryProvider.overrideWithValue(
        renewalRequestsRepository,
      ),
      authControllerProvider.overrideWith(
        (ref) => AuthController(
          authRepository: authRepository,
          initialSession: initialSession,
        ),
      ),
      initialSessionProvider.overrideWithValue(initialSession),
    ],
  );
}
