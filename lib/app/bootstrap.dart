import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception_mapper.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/dio_provider.dart';
import '../core/network/session_error_interceptor.dart';
import '../core/storage/app_secure_storage.dart';
import '../features/auth/data/repositories/app_auth_repository.dart';
import '../features/auth/data/services/auth_remote_data_source.dart';
import '../features/auth/data/services/session_local_data_source.dart';
import '../features/auth/domain/entities/session.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/branches/data/repositories/app_branches_repository.dart';
import '../features/branches/data/services/branches_remote_data_source.dart';
import '../features/branches/domain/repositories/branches_repository.dart';
import '../features/dashboard/data/repositories/app_dashboard_repository.dart';
import '../features/dashboard/data/services/dashboard_remote_data_source.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../features/notifications/data/repositories/app_notifications_repository.dart';
import '../features/notifications/domain/repositories/notifications_repository.dart';
import '../features/plans/data/repositories/app_plans_repository.dart';
import '../features/plans/data/services/plans_remote_data_source.dart';
import '../features/plans/domain/repositories/plans_repository.dart';
import '../features/reports/data/repositories/app_reports_repository.dart';
import '../features/reports/data/services/reports_remote_data_source.dart';
import '../features/reports/domain/repositories/reports_repository.dart';
import '../features/settings/data/repositories/app_renewal_requests_repository.dart';
import '../features/settings/data/repositories/app_support_repository.dart';
import '../features/settings/data/services/renewal_remote_data_source.dart';
import '../features/settings/data/services/support_remote_data_source.dart';
import '../features/settings/domain/repositories/renewal_requests_repository.dart';
import '../features/settings/domain/repositories/support_repository.dart';
import '../features/transactions/data/repositories/app_transactions_repository.dart';
import '../features/transactions/data/services/transactions_remote_data_source.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/users/data/repositories/app_users_repository.dart';
import '../features/users/data/services/users_remote_data_source.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/wallets/data/repositories/app_wallets_repository.dart';
import '../features/wallets/data/services/wallets_remote_data_source.dart';
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
  final dio = createDio(
    config: config,
    authInterceptor: authInterceptor,
    sessionErrorInterceptor: null,
  );
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
  Session? initialSession;
  try {
    initialSession = await authRepository.getCurrentSession();
  } catch (_) {
    initialSession = null;
  }
  final authController = AuthController(
    authRepository: authRepository,
    initialSession: initialSession,
  );
  final sessionErrorInterceptor = SessionErrorInterceptor(
    exceptionMapper: apiExceptionMapper,
    onUnauthorized: authController.handleUnauthorized,
  );
  final dioWithErrorHandler = createDio(
    config: config,
    authInterceptor: authInterceptor,
    sessionErrorInterceptor: sessionErrorInterceptor,
  );
  final apiClientWithErrorHandler = DioApiClient(dioWithErrorHandler);
  final walletsRemoteDataSource = DioWalletsRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final walletsRepository = AppWalletsRepository(
    remoteDataSource: walletsRemoteDataSource,
  );
  final transactionsRemoteDataSource = DioTransactionsRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final transactionsRepository = AppTransactionsRepository(
    remoteDataSource: transactionsRemoteDataSource,
  );
  final usersRemoteDataSource = DioUsersRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final usersRepository = AppUsersRepository(
    remoteDataSource: usersRemoteDataSource,
  );
  final branchesRemoteDataSource = DioBranchesRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final branchesRepository = AppBranchesRepository(
    remoteDataSource: branchesRemoteDataSource,
  );
  final dashboardRemoteDataSource = DioDashboardRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final dashboardRepository = AppDashboardRepository(
    remoteDataSource: dashboardRemoteDataSource,
  );
  final reportsRemoteDataSource = DioReportsRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final reportsRepository = AppReportsRepository(
    remoteDataSource: reportsRemoteDataSource,
  );
  final notificationsRemoteDataSource = DioNotificationsRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final notificationsRepository = AppNotificationsRepository(
    remoteDataSource: notificationsRemoteDataSource,
  );
  final plansRemoteDataSource = DioPlansRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final plansRepository = AppPlansRepository(
    remoteDataSource: plansRemoteDataSource,
  );

  final supportRemoteDataSource = DioSupportRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final supportRepository = AppSupportRepository(
    remoteDataSource: supportRemoteDataSource,
  );

  final renewalRemoteDataSource = DioRenewalRemoteDataSource(
    apiClient: apiClientWithErrorHandler,
    exceptionMapper: apiExceptionMapper,
  );
  final renewalRequestsRepository = AppRenewalRequestsRepository(
    remoteDataSource: renewalRemoteDataSource,
  );

  return ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      secureStorageProvider.overrideWithValue(secureStorage),
      sessionLocalDataSourceProvider.overrideWithValue(localDataSource),
      authInterceptorProvider.overrideWithValue(authInterceptor),
      dioProvider.overrideWithValue(dioWithErrorHandler),
      apiClientProvider.overrideWithValue(apiClientWithErrorHandler),
      apiExceptionMapperProvider.overrideWithValue(apiExceptionMapper),
      authRemoteDataSourceProvider.overrideWithValue(authRemoteDataSource),
      authRepositoryProvider.overrideWithValue(authRepository),
      walletsRemoteDataSourceProvider.overrideWithValue(
        walletsRemoteDataSource,
      ),
      walletsRepositoryProvider.overrideWithValue(walletsRepository),
      transactionsRemoteDataSourceProvider.overrideWithValue(
        transactionsRemoteDataSource,
      ),
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      usersRemoteDataSourceProvider.overrideWithValue(usersRemoteDataSource),
      usersRepositoryProvider.overrideWithValue(usersRepository),
      branchesRemoteDataSourceProvider.overrideWithValue(
        branchesRemoteDataSource,
      ),
      branchesRepositoryProvider.overrideWithValue(branchesRepository),
      dashboardRemoteDataSourceProvider.overrideWithValue(
        dashboardRemoteDataSource,
      ),
      dashboardRepositoryProvider.overrideWithValue(dashboardRepository),
      reportsRemoteDataSourceProvider.overrideWithValue(
        reportsRemoteDataSource,
      ),
      reportsRepositoryProvider.overrideWithValue(reportsRepository),
      notificationsRemoteDataSourceProvider.overrideWithValue(
        notificationsRemoteDataSource,
      ),
      notificationsRepositoryProvider.overrideWithValue(
        notificationsRepository,
      ),
      plansRepositoryProvider.overrideWithValue(plansRepository),
      supportRepositoryProvider.overrideWithValue(supportRepository),
      renewalRequestsRepositoryProvider.overrideWithValue(
        renewalRequestsRepository,
      ),
      authControllerProvider.overrideWith((ref) => authController),
      initialSessionProvider.overrideWithValue(initialSession),
    ],
  );
}
