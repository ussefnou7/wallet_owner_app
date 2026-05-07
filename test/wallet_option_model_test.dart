import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/features/wallets/data/models/wallet_option_model.dart';

void main() {
  test('maps standard wallet option payload', () {
    final option = WalletOptionModel.fromJson(const {
      'id': 'wallet-1',
      'name': 'Main Wallet',
      'number': 'MW-001',
      'branchId': 'branch-1',
    });

    expect(option.id, 'wallet-1');
    expect(option.name, 'Main Wallet');
    expect(option.number, 'MW-001');
    expect(option.branchId, 'branch-1');
  });

  test('falls back to code and nested branch id when fields differ', () {
    final option = WalletOptionModel.fromJson(const {
      'id': 42,
      'name': ' Branch Wallet ',
      'code': 'BW-014',
      'branch': {'id': 'branch-2'},
    });

    expect(option.id, '42');
    expect(option.name, 'Branch Wallet');
    expect(option.number, 'BW-014');
    expect(option.branchId, 'branch-2');
  });

  test('throws a format exception when id is missing', () {
    expect(
      () => WalletOptionModel.fromJson(const {
        'name': 'Invalid Wallet',
        'number': 'IW-001',
      }),
      throwsA(isA<FormatException>()),
    );
  });
}
