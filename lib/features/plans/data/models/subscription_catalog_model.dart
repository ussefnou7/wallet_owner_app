import '../../domain/entities/subscription_catalog.dart';
import 'plan_model.dart';
import 'subscription_summary_model.dart';

class SubscriptionCatalogModel extends SubscriptionCatalog {
  const SubscriptionCatalogModel({
    required super.currentSubscription,
    required super.plans,
  });

  factory SubscriptionCatalogModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionCatalogModel(
      currentSubscription: SubscriptionSummaryModel.fromJson(
        json['currentSubscription'] as Map<String, dynamic>,
      ),
      plans: (json['plans'] as List<dynamic>)
          .map((plan) => PlanModel.fromJson(plan as Map<String, dynamic>))
          .toList(),
    );
  }
}
