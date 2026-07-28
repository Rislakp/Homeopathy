import 'package:homeopathy/admin/models/subscription_model.dart';


class SubscriptionService {
  Future<List<SubscriptionPlanModel>> fetchPlans() async {
    // Simulate loading latency
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    return [
      SubscriptionPlanModel(
        id: 'plan-1',
        planName: 'Monthly Starter',
        price: 29.00,
        billingCycle: 'Monthly',
        description: 'Perfect for trying out homeopathic study materials and live sessions.',
        features: [
          'Access to 24 Materia Medica lectures',
          'Access to weekly live Q&A sessions',
          'Downloadable class notes & PDFs',
          'Email support assistance',
        ],
        isPopular: false,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      SubscriptionPlanModel(
        id: 'plan-2',
        planName: 'Quarterly Explorer',
        price: 79.00,
        billingCycle: 'Quarterly',
        description: 'Best choice for active clinical learners looking for deep repertory studies.',
        features: [
          'All Monthly Starter features',
          'Access to Kent\'s Repertory Analysis',
          'Access to mock examination papers',
          'Interactive discussion forum privileges',
          'Priority email support assistance',
        ],
        isPopular: true,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
      SubscriptionPlanModel(
        id: 'plan-3',
        planName: 'Yearly Professional',
        price: 199.00,
        billingCycle: 'Yearly',
        description: 'Great savings for dedicated doctors and advanced homeopathy students.',
        features: [
          'All Quarterly Explorer features',
          'Access to Case Study library (20+ cases)',
          'Hahnemannian Philosophy reviews',
          'Verified completion certificate',
          '1-on-1 quarterly mentor review call',
          '24/7 Priority chat & support',
        ],
        isPopular: false,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      SubscriptionPlanModel(
        id: 'plan-4',
        planName: 'Lifetime Ultimate Scholar',
        price: 499.00,
        billingCycle: 'Lifetime',
        description: 'One-time payment for perpetual access to all homeopathy materials and updates.',
        features: [
          'Unlimited lifetime access to all study materials',
          'Direct consultation with expert instructors',
          'Custom research project review & analysis',
          'Premium printed hardcopy certificate',
          'Lifetime webinar & symposium access',
          'Dedicated account manager',
        ],
        isPopular: false,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
