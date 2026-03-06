import 'package:bloc_test/bloc_test.dart';
import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/deck/domain/entities/deck.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/create_deck.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/delete_deck.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/get_decks.dart';
import 'package:card_mind_ai/features/deck/presentation/bloc/deck_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDecks extends Mock implements GetDecks {}

class MockCreateDeck extends Mock implements CreateDeck {}

class MockDeleteDeck extends Mock implements DeleteDeck {}

void main() {
  late DeckBloc bloc;
  late MockGetDecks mockGetDecks;
  late MockCreateDeck mockCreateDeck;
  late MockDeleteDeck mockDeleteDeck;

  setUp(() {
    mockGetDecks = MockGetDecks();
    mockCreateDeck = MockCreateDeck();
    mockDeleteDeck = MockDeleteDeck();
    bloc = DeckBloc(mockGetDecks, mockCreateDeck, mockDeleteDeck);
  });

  tearDown(() => bloc.close());

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const CreateDeckParams(name: '', description: ''));
    registerFallbackValue(const DeleteDeckParams(id: ''));
  });

  final tDecks = [
    Deck(
      id: '1',
      name: 'Test Deck',
      description: 'desc',
      createdAt: DateTime(2024),
    ),
  ];

  test('initial state is DeckInitial', () {
    expect(bloc.state, isA<DeckInitial>());
  });

  group('LoadDecks', () {
    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckLoaded] when successful',
      build: () {
        when(() => mockGetDecks(any()))
            .thenAnswer((_) async => Right(tDecks));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadDecks()),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckLoaded>().having((s) => s.decks, 'decks', tDecks),
      ],
    );

    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckError] when fails',
      build: () {
        when(() => mockGetDecks(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadDecks()),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckError>().having((s) => s.message, 'message', 'Cache error'),
      ],
    );
  });

  group('CreateDeckEvent', () {
    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckLoaded] when successful (reloads after create)',
      build: () {
        when(() => mockCreateDeck(any())).thenAnswer(
          (_) async => Right(tDecks.first),
        );
        when(() => mockGetDecks(any()))
            .thenAnswer((_) async => Right(tDecks));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const CreateDeckEvent(name: 'Test Deck', description: 'desc'),
      ),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckLoaded>().having((s) => s.decks, 'decks', tDecks),
      ],
    );

    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckError] when create fails',
      build: () {
        when(() => mockCreateDeck(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Create failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const CreateDeckEvent(name: 'Test', description: 'desc'),
      ),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckError>()
            .having((s) => s.message, 'message', 'Create failed'),
      ],
    );
  });

  group('DeleteDeckEvent', () {
    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckLoaded] when successful (reloads after delete)',
      build: () {
        when(() => mockDeleteDeck(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetDecks(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteDeckEvent(id: '1')),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckLoaded>().having((s) => s.decks, 'decks', isEmpty),
      ],
    );

    blocTest<DeckBloc, DeckState>(
      'emits [DeckLoading, DeckError] when delete fails',
      build: () {
        when(() => mockDeleteDeck(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Delete failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteDeckEvent(id: '1')),
      expect: () => [
        isA<DeckLoading>(),
        isA<DeckError>()
            .having((s) => s.message, 'message', 'Delete failed'),
      ],
    );
  });
}
