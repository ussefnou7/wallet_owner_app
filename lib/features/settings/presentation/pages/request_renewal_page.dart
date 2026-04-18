import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../core/widgets/subscription_summary_card.dart';
import '../../../plans/presentation/controllers/plans_controller.dart';
import '../../data/models/renewal_request_model.dart';
import '../controllers/request_renewal_controller.dart';
import '../widgets/renewal_success_banner.dart';

class RequestRenewalPage extends ConsumerStatefulWidget {
  const RequestRenewalPage({super.key});

  @override
  ConsumerState<RequestRenewalPage> createState() => _RequestRenewalPageState();
}

class _RequestRenewalPageState extends ConsumerState<RequestRenewalPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  String? _selectedPlanId;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(plansControllerProvider);
    final renewalState = ref.watch(requestRenewalControllerProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppPageScaffold(
        title: 'Request Renewal',
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
        endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.requestRenewal),
        bottomNavigationBar: AppBottomNavBar(
          currentRoute: '',
          onDestinationSelected: context.go,
        ),
        maxWidth: AppDimensions.compactContentMaxWidth,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: plansState.when(
            loading: () =>
                const AppLoadingView(message: 'Loading renewal options...'),
            error: (error, stackTrace) => AppErrorState(
              message: 'Unable to load renewal details right now.',
              onRetry: () =>
                  ref.read(plansControllerProvider.notifier).reload(),
            ),
            data: (catalog) {
              final availablePlans = catalog.plans;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionHeader(
                      title: 'Renewal Request',
                      subtitle:
                          'Confirm the current subscription, choose the next plan term, and send a request for follow-up.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SubscriptionSummaryCard(
                      summary: catalog.currentSubscription,
                      subtitle:
                          'Use this summary to decide whether to renew the same tier or request an upgrade.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (renewalState.lastResult != null) ...[
                      RenewalSuccessBanner(
                        requestId: renewalState.lastResult!.requestId,
                        targetPlanName: renewalState.lastResult!.targetPlanName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (renewalState.errorMessage != null) ...[
                      AppErrorState(
                        message: renewalState.errorMessage!,
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    AppFormSection(
                      title: 'Request Details',
                      subtitle:
                          'This sends a mock renewal request only. No billing or payment action is triggered in this phase.',
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDropdownField<String>(
                              value: _selectedPlanId,
                              label: 'Target plan',
                              hintText: 'Select a plan',
                              prefixIcon: const Icon(
                                Icons.workspace_premium_outlined,
                              ),
                              items: availablePlans
                                  .map(
                                    (plan) => DropdownMenuItem<String>(
                                      value: plan.id,
                                      child: Text(plan.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _selectedPlanId = value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a target plan';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              controller: _noteController,
                              label: 'Note',
                              hintText:
                                  'Optional context for the renewal request',
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(Icons.notes_rounded),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            SizedBox(
                              width: double.infinity,
                              child: AppPrimaryButton(
                                label: 'Submit Renewal Request',
                                isLoading: renewalState.isSubmitting,
                                onPressed: () => _submit(
                                  currentPlanId:
                                      catalog.currentSubscription.planId,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit({required String currentPlanId}) async {
    FocusScope.of(context).unfocus();
    ref.read(requestRenewalControllerProvider.notifier).clearFeedback();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final request = RenewalRequestModel(
      currentPlanId: currentPlanId,
      targetPlanId: _selectedPlanId!,
      note: _noteController.text.trim(),
    );

    final success = await ref
        .read(requestRenewalControllerProvider.notifier)
        .submit(request);

    if (!success || !mounted) {
      return;
    }

    final result = ref.read(requestRenewalControllerProvider).lastResult;
    if (result == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Renewal request submitted for ${result.targetPlanName}.',
        ),
      ),
    );

    _formKey.currentState?.reset();
    _noteController.clear();
    setState(() => _selectedPlanId = null);
  }
}
