import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_metric_card.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/report_column.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/entities/report_response.dart';
import '../../domain/entities/report_type.dart';
import '../controllers/reports_controller.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  late final TextEditingController _walletIdController;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _type;
  bool? _active;
  String? _period;

  @override
  void initState() {
    super.initState();
    _walletIdController = TextEditingController();
    _syncFromAppliedFilters(ref.read(reportsAppliedFiltersProvider));
  }

  @override
  void dispose() {
    _walletIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportsControllerProvider);
    final selectedReportType = ref.watch(reportsSelectedTypeProvider);
    final appliedFilters = ref.watch(reportsAppliedFiltersProvider);
    final walletsState = ref.watch(walletsControllerProvider);
    final l10n = appL10n(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppPageScaffold(
      title: l10n.reports,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.ownerReports),
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: ListView(
        padding: EdgeInsets.only(
          top: AppSpacing.md,
          bottom: bottomInset + AppDimensions.floatingBottomNavContentPadding,
        ),
        children: [
          AppSectionHeader(
            title: l10n.reports,
            subtitle: l10n.genericReportsSubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFormSection(
            title: l10n.selectReport,
            child: AppDropdownField<ReportType>(
              value: selectedReportType,
              items: ReportType.values.map((reportType) {
                return DropdownMenuItem(
                  value: reportType,
                  child: Text(_reportTypeLabel(l10n, reportType)),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                final sanitizedFilters = appliedFilters.sanitizedFor(value);
                ref
                    .read(reportsControllerProvider.notifier)
                    .selectReportType(value, currentFilters: appliedFilters);
                _syncFromAppliedFilters(sanitizedFilters);
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFormSection(
            title: l10n.filters,
            subtitle: l10n.dynamicFiltersSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FiltersGrid(
                  reportType: selectedReportType,
                  walletsState: walletsState,
                  selectedWalletId: _walletIdController.text.isEmpty
                      ? null
                      : _walletIdController.text,
                  fromDate: _fromDate,
                  toDate: _toDate,
                  selectedType: _type,
                  selectedActive: _active,
                  selectedPeriod: _period,
                  onPickFromDate: () => _pickDate(isFromDate: true),
                  onPickToDate: () => _pickDate(isFromDate: false),
                  onWalletIdChanged: (value) =>
                      setState(() => _walletIdController.text = value ?? ''),
                  onTypeChanged: (value) => setState(() => _type = value),
                  onActiveChanged: (value) => setState(() => _active = value),
                  onPeriodChanged: (value) => setState(() => _period = value),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        ref
                            .read(reportsControllerProvider.notifier)
                            .applyFilters(
                              ReportFilters(
                                fromDate: _fromDate,
                                toDate: _toDate,
                                walletId: _walletIdController.text,
                                type: _type,
                                active: _active,
                                period: _period,
                              ),
                            );
                      },
                      icon: const Icon(Icons.tune_rounded),
                      label: Text(l10n.applyFilters),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        final clearedFilters = ReportFilters.empty.sanitizedFor(
                          selectedReportType,
                        );
                        ref
                            .read(reportsControllerProvider.notifier)
                            .clearFilters();
                        _syncFromAppliedFilters(clearedFilters);
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear_rounded),
                      label: Text(l10n.clearFilters),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          ref.read(reportsControllerProvider.notifier).reload(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.refresh),
                    ),
                  ],
                ),
                if (_hasAppliedFilters(appliedFilters)) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _appliedFiltersSummary(
                      context,
                      selectedReportType,
                      appliedFilters,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          reportAsync.when(
            loading: () => AppLoadingView(message: l10n.loadingReports),
            error: (error, stackTrace) => AppErrorState(
              message: _errorMessage(error, l10n),
              onRetry: () =>
                  ref.read(reportsControllerProvider.notifier).reload(),
            ),
            data: (report) => _ReportResultSection(
              reportType: selectedReportType,
              report: report,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isFromDate}) async {
    final initialDate = (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (isFromDate) {
        _fromDate = picked;
      } else {
        _toDate = picked;
      }
    });
  }

  void _syncFromAppliedFilters(ReportFilters filters) {
    _fromDate = filters.fromDate;
    _toDate = filters.toDate;
    _walletIdController.text = filters.walletId ?? '';
    _type = filters.type;
    _active = filters.active;
    _period = filters.period;
  }
}

class _FiltersGrid extends StatelessWidget {
  const _FiltersGrid({
    required this.reportType,
    required this.walletsState,
    required this.selectedWalletId,
    required this.fromDate,
    required this.toDate,
    required this.selectedType,
    required this.selectedActive,
    required this.selectedPeriod,
    required this.onPickFromDate,
    required this.onPickToDate,
    required this.onWalletIdChanged,
    required this.onTypeChanged,
    required this.onActiveChanged,
    required this.onPeriodChanged,
  });

  final ReportType reportType;
  final WalletListState walletsState;
  final String? selectedWalletId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? selectedType;
  final bool? selectedActive;
  final String? selectedPeriod;
  final VoidCallback onPickFromDate;
  final VoidCallback onPickToDate;
  final ValueChanged<String?> onWalletIdChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<bool?> onActiveChanged;
  final ValueChanged<String?> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final fields = <Widget>[
      if (reportType.supportedFilters.contains(ReportFilterField.fromDate))
        _FilterFieldContainer(
          child: _ReadOnlyFilterField(
            label: l10n.fromDate,
            value: fromDate == null ? null : formatDate(fromDate!),
            onTap: onPickFromDate,
          ),
        ),
      if (reportType.supportedFilters.contains(ReportFilterField.toDate))
        _FilterFieldContainer(
          child: _ReadOnlyFilterField(
            label: l10n.toDate,
            value: toDate == null ? null : formatDate(toDate!),
            onTap: onPickToDate,
          ),
        ),
      if (reportType.supportedFilters.contains(ReportFilterField.walletId))
        _FilterFieldContainer(
          child: walletsState.isLoading
              ? AppLoadingView(message: l10n.loadingWalletOptions)
              : walletsState.error != null
              ? AppErrorState(
                  message: l10n.unableToLoadWalletOptions,
                  compact: true,
                )
              : AppDropdownField<String>(
                  value: selectedWalletId,
                  label: l10n.wallet,
                  hintText: l10n.selectWallet,
                  prefixIcon: const Icon(
                    Icons.account_balance_wallet_outlined,
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.all)),
                    ...walletsState.data.map(
                      (wallet) => DropdownMenuItem<String>(
                        value: wallet.id,
                        child: Text(wallet.name),
                      ),
                    ),
                  ],
                  onChanged: onWalletIdChanged,
                ),
        ),
      if (reportType.supportedFilters.contains(ReportFilterField.type))
        _FilterFieldContainer(
          child: AppDropdownField<String>(
            value: selectedType,
            label: l10n.type,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              const DropdownMenuItem(value: 'CREDIT', child: Text('CREDIT')),
              const DropdownMenuItem(value: 'DEBIT', child: Text('DEBIT')),
            ],
            onChanged: onTypeChanged,
          ),
        ),
      if (reportType.supportedFilters.contains(ReportFilterField.active))
        _FilterFieldContainer(
          child: AppDropdownField<bool>(
            value: selectedActive,
            label: l10n.active,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              DropdownMenuItem(value: true, child: Text(l10n.active)),
              DropdownMenuItem(value: false, child: Text(l10n.inactive)),
            ],
            onChanged: onActiveChanged,
          ),
        ),
      if (reportType.supportedFilters.contains(ReportFilterField.period))
        _FilterFieldContainer(
          child: AppDropdownField<String>(
            value: selectedPeriod ?? 'DAILY',
            label: l10n.period,
            items: [
              DropdownMenuItem(value: 'DAILY', child: Text(l10n.daily)),
              DropdownMenuItem(value: 'MONTHLY', child: Text(l10n.monthly)),
            ],
            onChanged: onPeriodChanged,
          ),
        ),
    ];

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: fields,
    );
  }
}

class _FilterFieldContainer extends StatelessWidget {
  const _FilterFieldContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 220, child: child);
  }
}

class _ReadOnlyFilterField extends StatelessWidget {
  const _ReadOnlyFilterField({
    required this.label,
    required this.onTap,
    this.value,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          value ?? '',
          style: value == null || value!.isEmpty
              ? theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _ReportResultSection extends StatelessWidget {
  const _ReportResultSection({required this.reportType, required this.report});

  final ReportType reportType;
  final ReportResponse report;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: _resolveBackendLabel(
            context,
            report.titleKey,
            fallback: _reportTypeLabel(l10n, reportType),
          ),
          subtitle: l10n.reportResultsSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        report.isEmpty
            ? AppEmptyState(
                title: l10n.noData,
                message: l10n.noReportData,
                icon: Icons.assessment_outlined,
              )
            : _buildReportContent(context, report),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context, ReportResponse report) {
    final data = report.data;

    if (data is Map<String, dynamic>) {
      final content = data['content'];
      if (content is List) {
        return _PaginatedReportRows(
          reportType: reportType,
          columns: report.columns,
          page: data,
        );
      }
      return _ReportCards(columns: report.columns, data: data);
    }

    if (data is List) {
      return _ReportRowsList(
        reportType: reportType,
        columns: report.columns,
        rows: data,
      );
    }

    return AppEmptyState(
      title: appL10n(context).noData,
      message: appL10n(context).unsupportedReportData,
      icon: Icons.table_chart_outlined,
    );
  }
}

class _ReportCards extends StatelessWidget {
  const _ReportCards({required this.columns, required this.data});

  final List<ReportColumn> columns;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final entries = columns.isNotEmpty
        ? columns
              .map((column) => MapEntry(column, data[column.key]))
              .where(
                (entry) =>
                    entry.value != null &&
                    !_isHiddenReportField(entry.key.key, entry.value),
              )
              .toList()
        : data.entries
              .map(
                (entry) => MapEntry(
                  ReportColumn(key: entry.key, labelKey: entry.key),
                  entry.value,
                ),
              )
              .where(
                (entry) =>
                    entry.value != null &&
                    !_isHiddenReportField(entry.key.key, entry.value),
              )
              .toList();

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnsCount = constraints.maxWidth >= 520 ? 2 : 1;
          final itemWidth =
              (constraints.maxWidth - (AppSpacing.md * (columnsCount - 1))) /
              columnsCount;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: entries.map((entry) {
              return SizedBox(
                width: itemWidth,
                child: AppMetricCard(
                  label: _resolveBackendLabel(
                    context,
                    entry.key.labelKey ?? entry.key.key,
                  ),
                  value: _formatValue(context, entry.value),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _ReportRowsList extends StatelessWidget {
  const _ReportRowsList({
    required this.reportType,
    required this.columns,
    required this.rows,
  });

  final ReportType reportType;
  final List<ReportColumn> columns;
  final List<dynamic> rows;

  @override
  Widget build(BuildContext context) {
    final normalizedRows = rows.whereType<Map>().map((row) {
      return row.map((key, value) => MapEntry('$key', value));
    }).toList();

    if (normalizedRows.isEmpty) {
      return AppEmptyState(
        title: appL10n(context).noData,
        message: appL10n(context).noReportData,
        icon: Icons.table_rows_outlined,
      );
    }

    final resolvedColumns = columns.isNotEmpty
        ? columns
        : normalizedRows.first.keys
              .map((key) => ReportColumn(key: key, labelKey: key))
              .toList();

    return Column(
      children: [
        for (var index = 0; index < normalizedRows.length; index++) ...[
          _buildRowCard(context, resolvedColumns, normalizedRows[index]),
          if (index < normalizedRows.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildRowCard(
    BuildContext context,
    List<ReportColumn> resolvedColumns,
    Map<String, dynamic> row,
  ) {
    return switch (reportType) {
      ReportType.transactionDetails => _TransactionDetailsCard(row: row),
      ReportType.walletConsumption => _WalletConsumptionCard(row: row),
      ReportType.transactionTimeAggregation => _TransactionTimeAggregationCard(
        row: row,
      ),
      _ => _GenericReportRowCard(columns: resolvedColumns, row: row),
    };
  }
}

class _PaginatedReportRows extends StatelessWidget {
  const _PaginatedReportRows({
    required this.reportType,
    required this.columns,
    required this.page,
  });

  final ReportType reportType;
  final List<ReportColumn> columns;
  final Map<String, dynamic> page;

  @override
  Widget build(BuildContext context) {
    final content = page['content'];
    final rows = content is List ? content : const [];
    final pageNumber = page['number'];
    final totalPages = page['totalPages'];
    final totalElements = page['totalElements'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReportRowsList(reportType: reportType, columns: columns, rows: rows),
        if (pageNumber != null || totalPages != null || totalElements != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              appL10n(context).pageSummary(
                _formatValue(context, pageNumber ?? 0),
                _formatValue(context, totalPages ?? 0),
                _formatValue(context, totalElements ?? 0),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _GenericReportRowCard extends StatelessWidget {
  const _GenericReportRowCard({required this.columns, required this.row});

  final List<ReportColumn> columns;
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final entries = columns
        .map((column) => MapEntry(column, row[column.key]))
        .where(
          (entry) =>
              entry.value != null &&
              !_isHiddenReportField(entry.key.key, entry.value),
        )
        .toList();

    return _ReportCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            _ReportFieldRow(
              label: _resolveBackendLabel(
                context,
                entries[index].key.labelKey ?? entries[index].key.key,
              ),
              value: _formatReportValue(
                context,
                entries[index].key.key,
                entries[index].value,
              ),
            ),
            if (index < entries.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _WalletConsumptionCard extends StatelessWidget {
  const _WalletConsumptionCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final walletName =
        _formatReportValue(context, 'walletName', row['walletName']) == '-'
        ? l10n.reportTypeWalletConsumption
        : _formatReportValue(context, 'walletName', row['walletName']);
    final branchName = row['branchName'];
    final tenantName = row['tenantName'];
    final isActive = row['active'];
    final updatedAt = row['updatedAt'];
    final nearDailyLimit = row['nearDailyLimit'] == true;
    final nearMonthlyLimit = row['nearMonthlyLimit'] == true;

    return _ReportCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  walletName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isActive != null)
                _ReportBadge(
                  label: _formatReportValue(context, 'active', isActive),
                  backgroundColor: isActive == true
                      ? AppColors.successSoft
                      : AppColors.surfaceVariant,
                  foregroundColor: isActive == true
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
            ],
          ),
          if (branchName != null || tenantName != null) ...[
            const SizedBox(height: AppSpacing.sm),
            if (branchName != null)
              Text(
                '${l10n.reportsFieldsBranchName}: ${_formatReportValue(context, 'branchName', branchName)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (tenantName != null) ...[
              if (branchName != null) const SizedBox(height: AppSpacing.xs),
              Text(
                '${l10n.reportsFieldsTenantName}: ${_formatReportValue(context, 'tenantName', tenantName)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _ConsumptionSummaryBox(
                  title: l10n.daily,
                  spentLabel: l10n.reportsFieldsDailySpent,
                  limitLabel: l10n.reportsFieldsDailyLimit,
                  spentValue: _formatReportValue(
                    context,
                    'dailySpent',
                    row['dailySpent'],
                  ),
                  limitValue: _formatReportValue(
                    context,
                    'dailyLimit',
                    row['dailyLimit'],
                  ),
                  percentLabel: l10n.reportsFieldsDailyPercent,
                  percentValue: _formatReportValue(
                    context,
                    'dailyPercent',
                    row['dailyPercent'],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ConsumptionSummaryBox(
                  title: l10n.monthly,
                  spentLabel: l10n.reportsFieldsMonthlySpent,
                  limitLabel: l10n.reportsFieldsMonthlyLimit,
                  spentValue: _formatReportValue(
                    context,
                    'monthlySpent',
                    row['monthlySpent'],
                  ),
                  limitValue: _formatReportValue(
                    context,
                    'monthlyLimit',
                    row['monthlyLimit'],
                  ),
                  percentLabel: l10n.reportsFieldsMonthlyPercent,
                  percentValue: _formatReportValue(
                    context,
                    'monthlyPercent',
                    row['monthlyPercent'],
                  ),
                ),
              ),
            ],
          ),
          if (nearDailyLimit || nearMonthlyLimit) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (nearDailyLimit)
                  _ReportBadge(
                    label: l10n.reportsFieldsNearDailyLimit,
                    backgroundColor: AppColors.warningSoft,
                    foregroundColor: AppColors.warning,
                  ),
                if (nearMonthlyLimit)
                  _ReportBadge(
                    label: l10n.reportsFieldsNearMonthlyLimit,
                    backgroundColor: AppColors.warningSoft,
                    foregroundColor: AppColors.warning,
                  ),
              ],
            ),
          ],
          if (updatedAt != null) ...[
            const SizedBox(height: AppSpacing.md),
            _ReportFieldRow(
              label: l10n.reportsFieldsUpdatedAt,
              value: _formatReportValue(context, 'updatedAt', updatedAt),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionDetailsCard extends StatelessWidget {
  const _TransactionDetailsCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final walletName =
        _formatReportValue(context, 'walletName', row['walletName']) == '-'
        ? l10n.reportTypeTransactionDetails
        : _formatReportValue(context, 'walletName', row['walletName']);
    final branchName = row['branchName'];
    final createdByUsername = row['createdByUsername'];
    final amount = _formatReportValue(context, 'amount', row['amount']);
    final type = _formatReportValue(context, 'type', row['type']);

    return _ReportCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      walletName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (branchName != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.branchName}: ${_formatReportValue(context, 'branchName', branchName)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (createdByUsername != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.createdByUser}: ${_formatReportValue(context, 'createdByUsername', createdByUsername)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _transactionAmountColor(row['type']),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ReportFieldRow(label: l10n.type, value: type),
          if (row['phoneNumber'] != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _ReportFieldRow(
              label: l10n.phoneNumber,
              value: _formatReportValue(
                context,
                'phoneNumber',
                row['phoneNumber'],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          _ReportFieldRow(
            label: l10n.cash,
            value: _formatReportValue(context, 'cash', row['cash']),
          ),
          if (row['occurredAt'] != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _ReportFieldRow(
              label: l10n.occurredAt,
              value: _formatReportValue(
                context,
                'occurredAt',
                row['occurredAt'],
              ),
            ),
          ],
          if (row['description'] != null &&
              _formatReportValue(context, 'description', row['description']) !=
                  '-') ...[
            const SizedBox(height: AppSpacing.sm),
            _ReportFieldRow(
              label: l10n.description,
              value: _formatReportValue(
                context,
                'description',
                row['description'],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTimeAggregationCard extends StatelessWidget {
  const _TransactionTimeAggregationCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return _ReportCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatReportValue(context, 'period', row['period']),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.netAmount,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _formatReportValue(
              context,
              'netAmount',
              row['netAmount'] ?? row['net'],
            ),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: _netAmountColor(row['netAmount'] ?? row['net']),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ReportFieldRow(
            label: l10n.totalCredits,
            value: _formatReportValue(
              context,
              'totalCredits',
              row['totalCredits'],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReportFieldRow(
            label: l10n.totalDebits,
            value: _formatReportValue(
              context,
              'totalDebits',
              row['totalDebits'],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReportFieldRow(
            label: l10n.transactionCount,
            value: _formatReportValue(
              context,
              'transactionCount',
              row['transactionCount'],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCardShell extends StatelessWidget {
  const _ReportCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

class _ConsumptionSummaryBox extends StatelessWidget {
  const _ConsumptionSummaryBox({
    required this.title,
    required this.spentLabel,
    required this.limitLabel,
    required this.spentValue,
    required this.limitValue,
    required this.percentLabel,
    required this.percentValue,
  });

  final String title;
  final String spentLabel;
  final String limitLabel;
  final String spentValue;
  final String limitValue;
  final String percentLabel;
  final String percentValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$spentValue / $limitValue',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$spentLabel / $limitLabel',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            percentValue,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            percentLabel,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ReportBadge extends StatelessWidget {
  const _ReportBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReportFieldRow extends StatelessWidget {
  const _ReportFieldRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

String _errorMessage(Object error, AppLocalizations l10n) {
  return ErrorMessageMapper.getMessage(error);
}

String _reportTypeLabel(AppLocalizations l10n, ReportType reportType) {
  return switch (reportType) {
    ReportType.transactionSummary => l10n.reportTypeTransactionSummary,
    ReportType.transactionDetails => l10n.reportTypeTransactionDetails,
    ReportType.walletConsumption => l10n.reportTypeWalletConsumption,
    ReportType.profitSummary => l10n.reportTypeProfitSummary,
    ReportType.transactionTimeAggregation =>
      l10n.reportTypeTransactionTimeAggregation,
  };
}

String _resolveBackendLabel(
  BuildContext context,
  String? key, {
  String? fallback,
}) {
  final l10n = appL10n(context);
  final normalized = key?.trim();

  if (normalized == null || normalized.isEmpty) {
    return fallback ?? l10n.unknown;
  }

  switch (normalized) {
    case 'reports.fields.totalCredits':
      return l10n.reportsFieldsTotalCredits;
    case 'reports.fields.totalDebits':
      return l10n.reportsFieldsTotalDebits;
    case 'reports.fields.netAmount':
      return l10n.reportsFieldsNetAmount;
    case 'reports.fields.transactionCount':
      return l10n.reportsFieldsTransactionCount;
    case 'reports.fields.walletName':
      return l10n.reportsFieldsWalletName;
    case 'reports.fields.branchName':
      return l10n.reportsFieldsBranchName;
    case 'reports.fields.tenantName':
      return l10n.reportsFieldsTenantName;
    case 'reports.fields.dailySpent':
      return l10n.reportsFieldsDailySpent;
    case 'reports.fields.monthlySpent':
      return l10n.reportsFieldsMonthlySpent;
    case 'reports.fields.dailyLimit':
      return l10n.reportsFieldsDailyLimit;
    case 'reports.fields.monthlyLimit':
      return l10n.reportsFieldsMonthlyLimit;
    case 'reports.fields.dailyPercent':
      return l10n.reportsFieldsDailyPercent;
    case 'reports.fields.monthlyPercent':
      return l10n.reportsFieldsMonthlyPercent;
    case 'reports.fields.updatedAt':
      return l10n.reportsFieldsUpdatedAt;
    case 'reports.fields.active':
      return l10n.reportsFieldsActive;
    case 'reports.fields.nearDailyLimit':
      return l10n.reportsFieldsNearDailyLimit;
    case 'reports.fields.nearMonthlyLimit':
      return l10n.reportsFieldsNearMonthlyLimit;
    case 'walletName':
      return l10n.walletName;
    case 'branchName':
      return l10n.branchName;
    case 'tenantName':
      return l10n.reportsFieldsTenantName;
    case 'walletId':
      return l10n.walletId;
    case 'amount':
      return l10n.amount;
    case 'totalCredits':
      return l10n.totalCredits;
    case 'totalDebits':
      return l10n.totalDebits;
    case 'totalTransactions':
      return l10n.totalTransactions;
    case 'transactionCount':
      return l10n.transactionCount;
    case 'netAmount':
      return l10n.netAmount;
    case 'type':
      return l10n.type;
    case 'active':
      return l10n.active;
    case 'dailySpent':
      return l10n.reportsFieldsDailySpent;
    case 'monthlySpent':
      return l10n.reportsFieldsMonthlySpent;
    case 'dailyLimit':
      return l10n.reportsFieldsDailyLimit;
    case 'monthlyLimit':
      return l10n.reportsFieldsMonthlyLimit;
    case 'dailyPercent':
      return l10n.reportsFieldsDailyPercent;
    case 'monthlyPercent':
      return l10n.reportsFieldsMonthlyPercent;
    case 'nearDailyLimit':
      return l10n.reportsFieldsNearDailyLimit;
    case 'nearMonthlyLimit':
      return l10n.reportsFieldsNearMonthlyLimit;
    case 'updatedAt':
      return l10n.reportsFieldsUpdatedAt;
    case 'cash':
      return l10n.cash;
    case 'phoneNumber':
      return l10n.phoneNumber;
    case 'description':
      return l10n.description;
    case 'occurredAt':
      return l10n.occurredAt;
    case 'period':
      return l10n.period;
    case 'net':
      return l10n.net;
    case 'createdByUsername':
      return l10n.createdByUser;
    case 'fromDate':
      return l10n.fromDate;
    case 'toDate':
      return l10n.toDate;
    case 'report.transactionSummary':
    case 'transactionSummary':
      return l10n.reportTypeTransactionSummary;
    case 'report.transactionDetails':
    case 'transactionDetails':
      return l10n.reportTypeTransactionDetails;
    case 'report.walletConsumption':
    case 'walletConsumption':
      return l10n.reportTypeWalletConsumption;
    case 'report.profitSummary':
    case 'profitSummary':
      return l10n.reportTypeProfitSummary;
    case 'report.transactionTimeAggregation':
    case 'transactionTimeAggregation':
      return l10n.reportTypeTransactionTimeAggregation;
  }

  return fallback ?? _humanizeKey(normalized);
}

String _humanizeKey(String value) {
  final withSpaces = value
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
        return '${match.group(1)} ${match.group(2)}';
      })
      .replaceAll('_', ' ')
      .replaceAll('.', ' ')
      .trim();

  if (withSpaces.isEmpty) {
    return value;
  }

  return withSpaces
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) {
          return word;
        }
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}

String _formatValue(BuildContext context, Object? value) {
  final l10n = appL10n(context);

  if (value == null) {
    return '-';
  }
  if (value is bool) {
    return value ? l10n.active : l10n.inactive;
  }
  if (value is num) {
    return value.toString();
  }
  if (value is String) {
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate != null) {
      return formatDate(parsedDate);
    }
    return value;
  }
  if (value is List) {
    return value.join(', ');
  }
  if (value is Map) {
    return value.toString();
  }
  return value.toString();
}

String _formatReportValue(BuildContext context, String key, Object? value) {
  final l10n = appL10n(context);

  if (value == null) {
    return '-';
  }

  if (value is bool) {
    if (key == 'cash') {
      return value ? l10n.yes : l10n.no;
    }
    return value ? l10n.active : l10n.inactive;
  }

  if (_isAmountField(key)) {
    final numericValue = _asNum(value);
    if (numericValue != null) {
      return formatCurrency(numericValue);
    }
  }

  if (value is num) {
    if (_isPercentField(key)) {
      return '${value.toString()}%';
    }
    return value.toString();
  }

  if (value is String) {
    if (key == 'type') {
      return switch (value.toUpperCase()) {
        'CREDIT' => l10n.credit,
        'DEBIT' => l10n.debit,
        _ => value,
      };
    }

    if (key == 'period') {
      return switch (value.toUpperCase()) {
        'DAILY' => l10n.daily,
        'MONTHLY' => l10n.monthly,
        _ => value,
      };
    }

    if (_isPercentField(key) && !value.trim().endsWith('%')) {
      return '${value.trim()}%';
    }

    final parsedDate = DateTime.tryParse(value);
    if (parsedDate != null) {
      if (key == 'occurredAt' || key == 'updatedAt') {
        return formatDateTime(parsedDate);
      }
      return formatDate(parsedDate);
    }

    return value;
  }

  return _formatValue(context, value);
}

bool _isAmountField(String key) {
  return key == 'amount' ||
      key == 'totalCredits' ||
      key == 'totalDebits' ||
      key == 'dailySpent' ||
      key == 'monthlySpent' ||
      key == 'dailyLimit' ||
      key == 'monthlyLimit' ||
      key == 'netAmount' ||
      key == 'net';
}

bool _isPercentField(String key) {
  return key == 'dailyPercent' || key == 'monthlyPercent';
}

num? _asNum(Object? value) {
  if (value is num) {
    return value;
  }
  if (value is String) {
    return num.tryParse(value);
  }
  return null;
}

Color _transactionAmountColor(Object? type) {
  if (type is String && type.toUpperCase() == 'DEBIT') {
    return AppColors.danger;
  }
  return AppColors.success;
}

Color _netAmountColor(Object? value) {
  final numericValue = _asNum(value);
  if (numericValue == null) {
    return AppColors.textPrimary;
  }
  if (numericValue < 0) {
    return AppColors.danger;
  }
  if (numericValue > 0) {
    return AppColors.success;
  }
  return AppColors.textPrimary;
}

bool _isHiddenReportField(String key, Object? value) {
  final normalizedKey = key.trim();
  final lowerKey = normalizedKey.toLowerCase();

  if (_isAllowedVisibleIdField(normalizedKey)) {
    return false;
  }

  if (lowerKey == 'id' ||
      lowerKey == 'tenantid' ||
      lowerKey == 'walletid' ||
      lowerKey == 'branchid' ||
      lowerKey == 'walletconsumptionid' ||
      lowerKey == 'transactionid' ||
      lowerKey.endsWith('id')) {
    return true;
  }

  if (value is String && _looksLikeUuid(value)) {
    return true;
  }

  return false;
}

bool _isAllowedVisibleIdField(String key) {
  return key == 'walletName' ||
      key == 'branchName' ||
      key == 'tenantName' ||
      key == 'createdByUsername';
}

bool _looksLikeUuid(String value) {
  return RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(value.trim());
}

bool _hasAppliedFilters(ReportFilters filters) {
  return filters != ReportFilters.empty;
}

String _appliedFiltersSummary(
  BuildContext context,
  ReportType reportType,
  ReportFilters filters,
) {
  final parts = <String>[];

  void addIfSupported(
    ReportFilterField field,
    String key,
    String label,
    Object? value,
  ) {
    if (!reportType.supportedFilters.contains(field) || value == null) {
      return;
    }
    final formatted = _formatReportValue(context, key, value);
    if (formatted == '-' || formatted.isEmpty) {
      return;
    }
    parts.add('$label: $formatted');
  }

  final l10n = appL10n(context);
  addIfSupported(
    ReportFilterField.fromDate,
    'fromDate',
    l10n.fromDate,
    filters.fromDate,
  );
  addIfSupported(
    ReportFilterField.toDate,
    'toDate',
    l10n.toDate,
    filters.toDate,
  );
  addIfSupported(
    ReportFilterField.walletId,
    'walletId',
    l10n.walletId,
    filters.walletId,
  );
  addIfSupported(ReportFilterField.type, 'type', l10n.type, filters.type);
  addIfSupported(
    ReportFilterField.active,
    'active',
    l10n.active,
    filters.active,
  );
  addIfSupported(
    ReportFilterField.period,
    'period',
    l10n.period,
    filters.period,
  );

  return parts.join(' | ');
}
