import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/subscription/domain/entities/subscription_status.dart';
import 'package:card_mind_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/restore_purchases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late RestorePurchases useCase;
  late MockSubscriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = RestorePurchases(mockRepository);
  });

  const tStatus = SubscriptionStatus(tier: SubscriptionTier.premium);

  test('should return subscription status on successful restore', () async {
    when(() => mockRepository.restorePurchases())
        .thenAnswer((_) async => const Right(tStatus));

    final result = await useCase(const NoParams());

    expect(result, const Right(tStatus));
    verify(() => mockRepository.restorePurchases()).called(1);
  });

  test('should return failure when restore fails', () async {
    when(() => mockRepository.restorePurchases()).thenAnswer(
        (_) async => const Left(PurchaseFailure('Geri yükleme başarısız')));

    final result = await useCase(const NoParams());

    expect(
        result, const Left(PurchaseFailure('Geri yükleme başarısız')));
  });
}
