import 'package:equatable/equatable.dart';

import 'plan.dart';
import 'subscription_summary.dart';

class SubscriptionCatalog extends Equatable {
  const SubscriptionCatalog({
    required this.currentSubscription,
    required this.plans,
  });

  final SubscriptionSummary currentSubscription;
  final List<Plan> plans;

  @override
  List<Object?> get props => [currentSubscription, plans];
}
