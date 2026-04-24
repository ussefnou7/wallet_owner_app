enum ReportFilterField { fromDate, toDate, walletId, type, active, period }

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
        ReportFilterField.walletId,
        ReportFilterField.type,
      },
      ReportType.transactionDetails => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.walletId,
        ReportFilterField.type,
        ReportFilterField.active,
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
        ReportFilterField.walletId,
        ReportFilterField.active,
      },
      ReportType.transactionTimeAggregation => {
        ReportFilterField.fromDate,
        ReportFilterField.toDate,
        ReportFilterField.walletId,
        ReportFilterField.period,
      },
    };
  }
}
