import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/subscription/domain/entities/subscription_status.dart';
import 'package:card_mind_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/get_subscription_status.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late GetSubscriptionStatus useCase;
  late MockSubscriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = GetSubscriptionStatus(mockRepository);
  });

  const tStatus = SubscriptionStatus(tier: SubscriptionTier.premium);

  test('should return subscription status from the repository', () async {
    when(() => mockRepository.getSubscriptionStatus())
        .thenAnswer((_) async => const Right(tStatus));

    final result = await useCase(const NoParams());

    expect(result, const Right(tStatus));
    verify(() => mockRepository.getSubscriptionStatus()).called(1);
  });

  test('should return failure when repository fails', () async {
    when(() => mockRepository.getSubscriptionStatus())
        .thenAnswer((_) async => const Left(PurchaseFailure('Hata')));

    final result = await useCase(const NoParams());

    expect(result, const Left(PurchaseFailure('Hata')));
  });
}
