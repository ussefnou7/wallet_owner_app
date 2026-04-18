import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/subscription_catalog.dart';

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  throw UnimplementedError(
    'plansRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class PlansRepository {
  Future<SubscriptionCatalog> getSubscriptionCatalog();
}
