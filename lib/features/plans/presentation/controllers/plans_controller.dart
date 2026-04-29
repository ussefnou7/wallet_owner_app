import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plan.dart';
import '../../domain/repositories/plans_repository.dart';

final plansControllerProvider =
    AsyncNotifierProvider<PlansController, List<Plan>>(PlansController.new);

class PlansController extends AsyncNotifier<List<Plan>> {
  @override
  Future<List<Plan>> build() async {
    final repository = ref.watch(plansRepositoryProvider);
    final plans = await repository.getPlans();
    return plans.where((plan) => plan.active).toList();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(plansRepositoryProvider);
      final plans = await repository.getPlans();
      return plans.where((plan) => plan.active).toList();
    });
  }
}
