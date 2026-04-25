import '../../domain/entities/branch.dart';
import '../../domain/repositories/branches_repository.dart';
import '../models/branch_model.dart';

class MockBranchesRepository implements BranchesRepository {
  final List<BranchModel> _branches = [
    const BranchModel(
      id: 'branch-1',
      name: 'Head Office',
      code: 'BR-HQ',
      usersCount: 6,
      walletsCount: 4,
      status: BranchStatus.active,
      location: 'Cairo, Downtown',
      tenantName: 'BTC',
      tenantId: 'tenant-1',
    ),
    const BranchModel(
      id: 'branch-2',
      name: 'Nasr City Branch',
      code: 'BR-NC',
      usersCount: 4,
      walletsCount: 2,
      status: BranchStatus.active,
      location: 'Cairo, Nasr City',
      tenantName: 'BTC',
      tenantId: 'tenant-1',
    ),
    const BranchModel(
      id: 'branch-3',
      name: 'Alexandria Branch',
      code: 'BR-ALX',
      usersCount: 3,
      walletsCount: 1,
      status: BranchStatus.inactive,
      location: 'Alexandria, Smouha',
      tenantName: 'BTC',
      tenantId: 'tenant-1',
    ),
    const BranchModel(
      id: 'branch-4',
      name: 'Maadi Branch',
      code: 'BR-MAD',
      usersCount: 5,
      walletsCount: 3,
      status: BranchStatus.active,
      location: 'Cairo, Maadi',
      tenantName: 'BTC',
      tenantId: 'tenant-1',
    ),
  ];

  @override
  Future<List<Branch>> getBranches() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return List<Branch>.from(_branches);
  }

  @override
  Future<Branch> createBranch(String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final branch = BranchModel(
      id: 'branch-${_branches.length + 1}',
      name: name,
      code: 'BR-${name.replaceAll(' ', '').toUpperCase()}',
      usersCount: 0,
      walletsCount: 0,
      status: BranchStatus.active,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
    );
    _branches.insert(0, branch);
    return branch;
  }

  @override
  Future<Branch> updateBranch(String branchId, String name, bool active) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _branches.indexWhere((branch) => branch.id == branchId);
    final current = _branches[index];
    final updated = BranchModel(
      id: current.id,
      name: name,
      code: current.code,
      usersCount: current.usersCount,
      walletsCount: current.walletsCount,
      status: active ? BranchStatus.active : BranchStatus.inactive,
      location: current.location,
      tenantId: current.tenantId,
      tenantName: current.tenantName,
    );
    _branches[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteBranch(String branchId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _branches.removeWhere((branch) => branch.id == branchId);
  }
}
