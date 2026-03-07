import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:card_mind_ai/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late CompleteOnboarding useCase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = CompleteOnboarding(mockRepository);
  });

  test(
    'should return Right(unit) when onboarding is successfully completed',
    () async {
      when(() => mockRepository.completeOnboarding())
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(const NoParams());

      expect(result, const Right(unit));
      verify(() => mockRepository.completeOnboarding()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return CacheFailure when repository fails to persist',
    () async {
      const tFailure = CacheFailure('Onboarding kaydedilemedi');
      when(() => mockRepository.completeOnboarding())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const NoParams());

      expect(result, const Left(tFailure));
      verify(() => mockRepository.completeOnboarding()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should delegate to repository exactly once per call',
    () async {
      when(() => mockRepository.completeOnboarding())
          .thenAnswer((_) async => const Right(unit));

      await useCase(const NoParams());
      await useCase(const NoParams());

      verify(() => mockRepository.completeOnboarding()).called(2);
    },
  );
}
