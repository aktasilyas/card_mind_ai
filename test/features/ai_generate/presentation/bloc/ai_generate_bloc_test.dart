import 'package:bloc_test/bloc_test.dart';
import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/ai_generate/domain/entities/generation_result.dart';
import 'package:card_mind_ai/features/ai_generate/domain/usecases/generate_cards_from_text.dart';
import 'package:card_mind_ai/features/ai_generate/presentation/bloc/ai_generate_bloc.dart';
import 'package:card_mind_ai/features/deck/domain/entities/flashcard.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGenerateCardsFromText extends Mock implements GenerateCardsFromText {}

void main() {
  late AiGenerateBloc bloc;
  late MockGenerateCardsFromText mockGenerateCards;

  setUp(() {
    mockGenerateCards = MockGenerateCardsFromText();
    bloc = AiGenerateBloc(mockGenerateCards);
  });

  tearDown(() => bloc.close());

  setUpAll(() {
    registerFallbackValue(
      const GenerateCardsParams(text: '', count: 5),
    );
  });

  final tCards = [
    Flashcard(
      id: '1',
      deckId: '',
      front: 'Soru 1',
      back: 'Cevap 1',
      dueDate: DateTime(2024),
    ),
  ];

  final tResult = GenerationResult(
    generatedCards: tCards,
    inputText: 'Test',
    generatedAt: DateTime(2024),
  );

  test('initial state is AiGenerateInitial', () {
    expect(bloc.state, isA<AiGenerateInitial>());
  });

  group('GenerateCards', () {
    blocTest<AiGenerateBloc, AiGenerateState>(
      'emits [Loading, Success] when generation succeeds',
      build: () {
        when(() => mockGenerateCards(any()))
            .thenAnswer((_) async => Right(tResult));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const GenerateCards(text: 'Test metin')),
      expect: () => [
        isA<AiGenerateLoading>(),
        isA<AiGenerateSuccess>()
            .having((s) => s.cards, 'cards', tCards),
      ],
    );

    blocTest<AiGenerateBloc, AiGenerateState>(
      'emits [Loading, Error] when generation fails',
      build: () {
        when(() => mockGenerateCards(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const GenerateCards(text: 'Test metin')),
      expect: () => [
        isA<AiGenerateLoading>(),
        isA<AiGenerateError>()
            .having((s) => s.message, 'message', 'Server error'),
      ],
    );

    blocTest<AiGenerateBloc, AiGenerateState>(
      'emits [Loading, LimitReached] when limit exceeded',
      build: () {
        when(() => mockGenerateCards(any())).thenAnswer(
          (_) async =>
              const Left(LimitExceededFailure('Limit aşıldı')),
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const GenerateCards(text: 'Test metin')),
      expect: () => [
        isA<AiGenerateLoading>(),
        isA<AiGenerateLimitReached>(),
      ],
    );

    blocTest<AiGenerateBloc, AiGenerateState>(
      'emits [Loading, Error] when network failure',
      build: () {
        when(() => mockGenerateCards(any())).thenAnswer(
          (_) async =>
              const Left(NetworkFailure('İnternet bağlantısı bulunamadı')),
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const GenerateCards(text: 'Test metin')),
      expect: () => [
        isA<AiGenerateLoading>(),
        isA<AiGenerateError>().having(
          (s) => s.message,
          'message',
          'İnternet bağlantısı bulunamadı',
        ),
      ],
    );
  });
}
