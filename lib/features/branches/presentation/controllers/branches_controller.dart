import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/branch.dart';
import '../../domain/repositories/branches_repository.dart';

enum BranchStatusFilter { all, active, inactive }

final branchesSearchQueryProvider = StateProvider<String>((ref) => '');
final branchesStatusFilterProvider = StateProvider<BranchStatusFilter>(
  (ref) => BranchStatusFilter.all,
);

final branchesControllerProvider =
    AsyncNotifierProvider<BranchesController, List<Branch>>(
      BranchesController.new,
    );

final filteredBranchesProvider = Provider<List<Branch>>((ref) {
  final branchesAsync = ref.watch(branchesControllerProvider);
  final query = ref.watch(branchesSearchQueryProvider).trim().toLowerCase();
  final statusFilter = ref.watch(branchesStatusFilterProvider);

  return branchesAsync.maybeWhen(
    data: (branches) {
      final statusFiltered = switch (statusFilter) {
        BranchStatusFilter.all => branches,
        BranchStatusFilter.active =>
          branches
              .where((branch) => branch.status == BranchStatus.active)
              .toList(),
        BranchStatusFilter.inactive =>
          branches
              .where((branch) => branch.status == BranchStatus.inactive)
              .toList(),
      };

      if (query.isEmpty) {
        return statusFiltered;
      }

      return statusFiltered.where((branch) {
        return branch.name.toLowerCase().contains(query) ||
            branch.code.toLowerCase().contains(query);
      }).toList();
    },
    orElse: () => const [],
  );
});

class BranchesController extends AsyncNotifier<List<Branch>> {
  @override
  Future<List<Branch>> build() async {
    final repository = ref.watch(branchesRepositoryProvider);
    return repository.getBranches();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(branchesRepositoryProvider);
      return repository.getBranches();
    });
  }

  void updateQuery(String value) {
    ref.read(branchesSearchQueryProvider.notifier).state = value;
  }

  void updateStatusFilter(BranchStatusFilter value) {
    ref.read(branchesStatusFilterProvider.notifier).state = value;
  }
}
