import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/branch.dart';

final branchesRepositoryProvider = Provider<BranchesRepository>((ref) {
  throw UnimplementedError(
    'branchesRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class BranchesRepository {
  Future<List<Branch>> getBranches();
}
