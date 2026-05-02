import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/features/wallets/data/models/wallet_model.dart';

void main() {
  test('maps collection metadata from exact backend field names', () {
    final wallet = WalletModel.fromJson(const {
      'id': 'wallet-1',
      'name': 'Main Wallet',
      'code': 'MW-001',
      'balance': 154200,
      'status': 'ACTIVE',
      'transactionCount': 428,
      'collectedAt': '2026-05-02T11:30:00Z',
      'collectedByName': 'Ussef',
    });

    expect(wallet.collectedAt, DateTime.parse('2026-05-02T11:30:00Z'));
    expect(wallet.collectedByName, 'Ussef');
  });

  test('trims collectedByName and keeps date-only collection metadata', () {
    final wallet = WalletModel.fromJson(const {
      'id': 'wallet-2',
      'name': 'Branch Wallet',
      'code': 'BW-014',
      'balance': 38420,
      'status': 'ACTIVE',
      'transactionCount': 163,
      'collectedAt': '2026-05-01T10:15:00Z',
      'collectedByName': '  ',
    });

    expect(wallet.collectedAt, DateTime.parse('2026-05-01T10:15:00Z'));
    expect(wallet.collectedByName, isNull);
  });
}
