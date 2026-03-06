import 'package:bloc_test/bloc_test.dart';
import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/subscription/domain/entities/subscription_status.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/get_subscription_status.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/purchase_premium.dart';
import 'package:card_mind_ai/features/subscription/domain/usecases/restore_purchases.dart';
import 'package:card_mind_ai/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSubscriptionStatus extends Mock
    implements GetSubscriptionStatus {}

class MockPurchasePremium extends Mock implements PurchasePremium {}

class MockRestorePurchases extends Mock implements RestorePurchases {}

void main() {
  late SubscriptionBloc bloc;
  late MockGetSubscriptionStatus mockGetStatus;
  late MockPurchasePremium mockPurchase;
  late MockRestorePurchases mockRestore;

  setUp(() {
    mockGetStatus = MockGetSubscriptionStatus();
    mockPurchase = MockPurchasePremium();
    mockRestore = MockRestorePurchases();
    bloc = SubscriptionBloc(mockGetStatus, mockPurchase, mockRestore);
  });

  tearDown(() => bloc.close());

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  const tPremiumStatus = SubscriptionStatus(tier: SubscriptionTier.premium);
  const tFreeStatus = SubscriptionStatus(tier: SubscriptionTier.free);

  test('initial state is SubscriptionInitial', () {
    expect(bloc.state, isA<SubscriptionInitial>());
  });

  group('LoadSubscription', () {
    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Loaded] when status is fetched successfully',
      build: () {
        when(() => mockGetStatus(any()))
            .thenAnswer((_) async => const Right(tPremiumStatus));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadSubscription()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionLoaded>()
            .having((s) => s.status.tier, 'tier', SubscriptionTier.premium),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Error] when fetching status fails',
      build: () {
        when(() => mockGetStatus(any()))
            .thenAnswer((_) async => const Left(PurchaseFailure('Hata')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadSubscription()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionError>().having((s) => s.message, 'message', 'Hata'),
      ],
    );
  });

  group('PurchasePremiumEvent', () {
    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Loaded] when purchase succeeds',
      build: () {
        when(() => mockPurchase(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetStatus(any()))
            .thenAnswer((_) async => const Right(tPremiumStatus));
        return bloc;
      },
      act: (bloc) => bloc.add(const PurchasePremiumEvent()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionLoaded>()
            .having((s) => s.status.tier, 'tier', SubscriptionTier.premium),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Error] when purchase fails',
      build: () {
        when(() => mockPurchase(any())).thenAnswer(
            (_) async => const Left(PurchaseFailure('Satın alma başarısız')));
        return bloc;
      },
      act: (bloc) => bloc.add(const PurchasePremiumEvent()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionError>()
            .having((s) => s.message, 'message', 'Satın alma başarısız'),
      ],
    );
  });

  group('RestorePurchasesEvent', () {
    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Loaded] when restore succeeds',
      build: () {
        when(() => mockRestore(any()))
            .thenAnswer((_) async => const Right(tFreeStatus));
        return bloc;
      },
      act: (bloc) => bloc.add(const RestorePurchasesEvent()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionLoaded>()
            .having((s) => s.status.tier, 'tier', SubscriptionTier.free),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'emits [Loading, Error] when restore fails',
      build: () {
        when(() => mockRestore(any())).thenAnswer((_) async =>
            const Left(PurchaseFailure('Geri yükleme başarısız')));
        return bloc;
      },
      act: (bloc) => bloc.add(const RestorePurchasesEvent()),
      expect: () => [
        isA<SubscriptionLoading>(),
        isA<SubscriptionError>()
            .having((s) => s.message, 'message', 'Geri yükleme başarısız'),
      ],
    );
  });
}
