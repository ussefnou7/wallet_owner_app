import '../../domain/entities/branch.dart';
import '../../domain/repositories/branches_repository.dart';
import '../models/branch_model.dart';

class MockBranchesRepository implements BranchesRepository {
  @override
  Future<List<Branch>> getBranches() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    return const [
      BranchModel(
        id: 'branch-1',
        name: 'Head Office',
        code: 'BR-HQ',
        usersCount: 6,
        walletsCount: 4,
        status: BranchStatus.active,
        location: 'Cairo, Downtown',
      ),
      BranchModel(
        id: 'branch-2',
        name: 'Nasr City Branch',
        code: 'BR-NC',
        usersCount: 4,
        walletsCount: 2,
        status: BranchStatus.active,
        location: 'Cairo, Nasr City',
      ),
      BranchModel(
        id: 'branch-3',
        name: 'Alexandria Branch',
        code: 'BR-ALX',
        usersCount: 3,
        walletsCount: 1,
        status: BranchStatus.inactive,
        location: 'Alexandria, Smouha',
      ),
      BranchModel(
        id: 'branch-4',
        name: 'Maadi Branch',
        code: 'BR-MAD',
        usersCount: 5,
        walletsCount: 3,
        status: BranchStatus.active,
        location: 'Cairo, Maadi',
      ),
    ];
  }
}
