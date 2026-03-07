import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('isOnboardingCompleted', () {
    test(
      'should return false when onboarding_completed key is not set',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.isOnboardingCompleted();

        expect(result, const Right(false));
      },
    );

    test(
      'should return false when onboarding_completed is explicitly false',
      () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': false,
        });
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.isOnboardingCompleted();

        expect(result, const Right(false));
      },
    );

    test(
      'should return true when onboarding_completed is true',
      () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': true,
        });
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.isOnboardingCompleted();

        expect(result, const Right(true));
      },
    );
  });

  group('completeOnboarding', () {
    test(
      'should persist onboarding_completed as true and return Right(unit)',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.completeOnboarding();

        expect(result, const Right(unit));
        expect(prefs.getBool('onboarding_completed'), true);
      },
    );

    test(
      'should overwrite existing false value and return Right(unit)',
      () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': false,
        });
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.completeOnboarding();

        expect(result, const Right(unit));
        expect(prefs.getBool('onboarding_completed'), true);
      },
    );

    test(
      'isOnboardingCompleted should return true after completeOnboarding is called',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        await repository.completeOnboarding();
        final result = await repository.isOnboardingCompleted();

        expect(result, const Right(true));
      },
    );
  });

  group('failure type', () {
    test(
      'result should be Left(CacheFailure) type when error occurs',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        repository = OnboardingRepositoryImpl(prefs);

        final result = await repository.isOnboardingCompleted();

        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (value) => expect(value, isA<bool>()),
        );
      },
    );
  });
}
