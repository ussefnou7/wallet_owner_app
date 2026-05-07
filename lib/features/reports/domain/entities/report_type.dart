enum ReportFilterField {
  fromDate,
  toDate,
  branchId,
  walletId,
  type,
  active,
  period,
  createdBy,
}

enum ReportType {
  transactionSummary,
  transactionDetails,
  walletConsumption,
  profitSummary,
  transactionTimeAggregation,
}

extension ReportTypeX on ReportType {
  String get path {
    return switch (this) {
      ReportType.transactionSummary => '/api/v1/reports/transactions/summary',
      ReportType.transactionDetails => '/api/v1/reports/transactions/details',
      ReportType.walletConsumption => '/api/v1/reports/wallets/consumption',
      ReportType.profitSummary => '/api/v1/reports/profit/summary',
      ReportType.transactionTimeAggregation =>
        '/api/v1/reports/transactions/time-aggregation',
    };
  }

  Set<ReportFilterField> get supportedFilters {
    return switch (this) {
      ReportType.transactionSummary => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.branchId,
        ReportFilterField.walletId,
        ReportFilterField.type,
        ReportFilterField.createdBy,
      },
      ReportType.transactionDetails => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.branchId,
        ReportFilterField.walletId,
        ReportFilterField.type,
        ReportFilterField.createdBy,
      },
      ReportType.walletConsumption => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.walletId,
        ReportFilterField.active,
      },
      ReportType.profitSummary => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.branchId,
        ReportFilterField.walletId,
      },
      ReportType.transactionTimeAggregation => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.walletId,
        ReportFilterField.period,
      },
    };
  }

  bool get isVisibleInProduction {
    return switch (this) {
      ReportType.transactionSummary => true,
      ReportType.transactionDetails => true,
      ReportType.profitSummary => true,
      ReportType.walletConsumption => false,
      ReportType.transactionTimeAggregation => false,
    };
  }
}
