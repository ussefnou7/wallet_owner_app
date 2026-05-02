import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/features/users/data/models/app_user_model.dart';

void main() {
  test('maps active flag from backend active field', () {
    final user = AppUserModel.fromJson(const {
      'id': 'user-1',
      'username': 'inactive.user',
      'role': 'USER',
      'tenantName': 'BTC',
      'active': false,
    });

    expect(user.active, isFalse);
  });

  test('maps active flag from backend isActive field', () {
    final user = AppUserModel.fromJson(const {
      'id': 'user-2',
      'username': 'inactive.user',
      'role': 'USER',
      'tenantName': 'BTC',
      'isActive': false,
    });

    expect(user.active, isFalse);
  });
}
