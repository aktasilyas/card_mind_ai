import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:card_mind_ai/features/onboarding/domain/usecases/is_onboarding_completed.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late IsOnboardingCompleted useCase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = IsOnboardingCompleted(mockRepository);
  });

  test(
    'should return true from repository when onboarding is completed',
    () async {
      when(() => mockRepository.isOnboardingCompleted())
          .thenAnswer((_) async => const Right(true));

      final result = await useCase(const NoParams());

      expect(result, const Right(true));
      verify(() => mockRepository.isOnboardingCompleted()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return false from repository when onboarding is not completed',
    () async {
      when(() => mockRepository.isOnboardingCompleted())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase(const NoParams());

      expect(result, const Right(false));
      verify(() => mockRepository.isOnboardingCompleted()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return CacheFailure when repository fails',
    () async {
      const tFailure = CacheFailure('Cache okunamadı');
      when(() => mockRepository.isOnboardingCompleted())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const NoParams());

      expect(result, const Left(tFailure));
      verify(() => mockRepository.isOnboardingCompleted()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
