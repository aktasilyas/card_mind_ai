import 'package:card_mind_ai/core/constants/app_constants.dart';
import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/ai_generate/domain/entities/generation_result.dart';
import 'package:card_mind_ai/features/ai_generate/domain/repositories/ai_generate_repository.dart';
import 'package:card_mind_ai/features/ai_generate/domain/usecases/generate_cards_from_text.dart';
import 'package:card_mind_ai/features/deck/domain/entities/flashcard.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAiGenerateRepository extends Mock implements AiGenerateRepository {}

void main() {
  late GenerateCardsFromText usecase;
  late MockAiGenerateRepository mockRepository;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    mockRepository = MockAiGenerateRepository();
    usecase = GenerateCardsFromText(mockRepository, prefs);
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
    inputText: 'Test metin',
    generatedAt: DateTime(2024),
  );

  const tParams = GenerateCardsParams(text: 'Test metin', count: 5);

  test('should return GenerationResult when under daily limit', () async {
    when(() => mockRepository.generateCards(any(), any()))
        .thenAnswer((_) async => Right(tResult));

    final result = await usecase(tParams);

    expect(result.isRight(), true);
    verify(() => mockRepository.generateCards('Test metin', 5)).called(1);
  });

  test('should increment daily counter on success', () async {
    when(() => mockRepository.generateCards(any(), any()))
        .thenAnswer((_) async => Right(tResult));

    await usecase(tParams);

    final today = DateTime.now();
    final key =
        '${AppConstants.dailyLimitKey}${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    expect(prefs.getInt(key), 1);
  });

  test('should return LimitExceededFailure when limit reached', () async {
    final today = DateTime.now();
    final key =
        '${AppConstants.dailyLimitKey}${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await prefs.setInt(key, AppConstants.freeAiGenerationLimit);

    final result = await usecase(tParams);

    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<LimitExceededFailure>()),
      (_) => fail('Should be Left'),
    );
    verifyNever(() => mockRepository.generateCards(any(), any()));
  });

  test('should not increment counter on failure', () async {
    when(() => mockRepository.generateCards(any(), any()))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    await usecase(tParams);

    final today = DateTime.now();
    final key =
        '${AppConstants.dailyLimitKey}${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    expect(prefs.getInt(key), isNull);
  });

  test('should return ServerFailure from repository', () async {
    const tFailure = ServerFailure('Server error');
    when(() => mockRepository.generateCards(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParams);

    expect(result, const Left(tFailure));
  });
}
