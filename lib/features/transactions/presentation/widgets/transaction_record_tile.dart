import 'package:flutter/material.dart';

import '../../../../core/localization/app_l10n.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import 'compact_transaction_list_item.dart';

class TransactionRecordTile extends StatelessWidget {
  const TransactionRecordTile({required this.transaction, super.key});

  final TransactionRecord transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final isCredit = transaction.type == TransactionEntryType.credit;
    final typeLabel = switch (transaction.type) {
      TransactionEntryType.debit => l10n.debit,
      TransactionEntryType.credit => l10n.credit,
      TransactionEntryType.unknown => l10n.unknown,
    };
    return CompactTransactionListItem(
      walletName: transaction.walletName,
      amount: transaction.amount,
      isCredit: isCredit,
      typeLabel: typeLabel,
      recordedAt: transaction.occurredAt ?? transaction.createdAt ?? transaction.date,
      createdByUsername: transaction.createdByUsername?.trim().isEmpty == true
          ? null
          : transaction.createdByUsername,
      wrapInCard: true,
    );
  }
}
