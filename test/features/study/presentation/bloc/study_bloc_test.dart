import 'package:bloc_test/bloc_test.dart';
import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/deck/domain/entities/flashcard.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/get_due_cards.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/update_card.dart';
import 'package:card_mind_ai/features/study/presentation/bloc/study_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDueCards extends Mock implements GetDueCards {}

class MockUpdateCard extends Mock implements UpdateCard {}

void main() {
  late StudyBloc bloc;
  late MockGetDueCards mockGetDueCards;
  late MockUpdateCard mockUpdateCard;

  setUp(() {
    mockGetDueCards = MockGetDueCards();
    mockUpdateCard = MockUpdateCard();
    bloc = StudyBloc(mockGetDueCards, mockUpdateCard);
  });

  tearDown(() => bloc.close());

  setUpAll(() {
    registerFallbackValue(const GetDueCardsParams(deckId: ''));
    registerFallbackValue(Flashcard(
      id: '',
      deckId: '',
      front: '',
      back: '',
      dueDate: DateTime(2024),
    ));
  });

  final tCards = [
    Flashcard(
      id: '1',
      deckId: 'deck1',
      front: 'Soru 1',
      back: 'Cevap 1',
      dueDate: DateTime(2024),
    ),
    Flashcard(
      id: '2',
      deckId: 'deck1',
      front: 'Soru 2',
      back: 'Cevap 2',
      dueDate: DateTime(2024),
    ),
  ];

  test('initial state is StudyInitial', () {
    expect(bloc.state, isA<StudyInitial>());
  });

  group('LoadStudySession', () {
    blocTest<StudyBloc, StudyState>(
      'emits [Loading, InProgress] when cards are available',
      build: () {
        when(() => mockGetDueCards(any()))
            .thenAnswer((_) async => Right(tCards));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadStudySession('deck1')),
      expect: () => [
        isA<StudyLoading>(),
        isA<StudyInProgress>()
            .having((s) => s.session.cards.length, 'cards', 2),
      ],
    );

    blocTest<StudyBloc, StudyState>(
      'emits [Loading, Empty] when no due cards',
      build: () {
        when(() => mockGetDueCards(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadStudySession('deck1')),
      expect: () => [
        isA<StudyLoading>(),
        isA<StudyEmpty>(),
      ],
    );

    blocTest<StudyBloc, StudyState>(
      'emits [Loading, Error] when fetching fails',
      build: () {
        when(() => mockGetDueCards(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Hata')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadStudySession('deck1')),
      expect: () => [
        isA<StudyLoading>(),
        isA<StudyError>().having((s) => s.message, 'message', 'Hata'),
      ],
    );
  });

  group('RateCard', () {
    blocTest<StudyBloc, StudyState>(
      'advances to next card after rating',
      build: () {
        when(() => mockGetDueCards(any()))
            .thenAnswer((_) async => Right(tCards));
        when(() => mockUpdateCard(any()))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const LoadStudySession('deck1'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const FlipCard());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const RateCard(4));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<StudyLoading>(),
        isA<StudyInProgress>()
            .having((s) => s.session.currentIndex, 'index', 0),
        isA<StudyInProgress>().having((s) => s.isFlipped, 'flipped', true),
        isA<StudyInProgress>()
            .having((s) => s.session.currentIndex, 'index', 1),
      ],
    );

    blocTest<StudyBloc, StudyState>(
      'emits StudyComplete when last card is rated',
      build: () {
        when(() => mockGetDueCards(any())).thenAnswer(
          (_) async => Right([tCards.first]),
        );
        when(() => mockUpdateCard(any()))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const LoadStudySession('deck1'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const FlipCard());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const RateCard(5));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<StudyLoading>(),
        isA<StudyInProgress>(),
        isA<StudyInProgress>().having((s) => s.isFlipped, 'flipped', true),
        isA<StudyComplete>()
            .having((s) => s.totalCards, 'total', 1)
            .having((s) => s.averageRating, 'avg', 5.0),
      ],
    );
  });
}
