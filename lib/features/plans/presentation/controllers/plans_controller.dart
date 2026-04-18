import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/subscription_catalog.dart';
import '../../domain/repositories/plans_repository.dart';

final plansControllerProvider =
    AsyncNotifierProvider<PlansController, SubscriptionCatalog>(
      PlansController.new,
    );

class PlansController extends AsyncNotifier<SubscriptionCatalog> {
  @override
  Future<SubscriptionCatalog> build() async {
    final repository = ref.watch(plansRepositoryProvider);
    return repository.getSubscriptionCatalog();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(plansRepositoryProvider);
      return repository.getSubscriptionCatalog();
    });
  }
}
