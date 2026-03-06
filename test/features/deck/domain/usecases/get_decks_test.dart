import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/core/usecases/usecase.dart';
import 'package:card_mind_ai/features/deck/domain/entities/deck.dart';
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/get_decks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  late GetDecks usecase;
  late MockDeckRepository mockRepository;

  setUp(() {
    mockRepository = MockDeckRepository();
    usecase = GetDecks(mockRepository);
  });

  final tDecks = [
    Deck(
      id: '1',
      name: 'Test Deck',
      description: 'A test deck',
      createdAt: DateTime(2024),
    ),
    Deck(
      id: '2',
      name: 'Another Deck',
      description: 'Another test deck',
      createdAt: DateTime(2024),
    ),
  ];

  test('should return list of decks from repository', () async {
    when(() => mockRepository.getAllDecks())
        .thenAnswer((_) async => Right(tDecks));

    final result = await usecase(const NoParams());

    expect(result, Right(tDecks));
    verify(() => mockRepository.getAllDecks()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure when repository fails', () async {
    const tFailure = CacheFailure('Cache error');
    when(() => mockRepository.getAllDecks())
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(const NoParams());

    expect(result, const Left(tFailure));
    verify(() => mockRepository.getAllDecks()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
