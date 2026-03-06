import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/purchase_premium.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late PurchasePremium useCase;
  late MockSubscriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = PurchasePremium(mockRepository);
  });

  test('should return unit on successful purchase', () async {
    when(() => mockRepository.purchasePremium())
        .thenAnswer((_) async => const Right(unit));

    final result = await useCase(const NoParams());

    expect(result, const Right(unit));
    verify(() => mockRepository.purchasePremium()).called(1);
  });

  test('should return failure when purchase fails', () async {
    when(() => mockRepository.purchasePremium()).thenAnswer(
        (_) async => const Left(PurchaseFailure('Satın alma başarısız')));

    final result = await useCase(const NoParams());

    expect(result, const Left(PurchaseFailure('Satın alma başarısız')));
  });
}
