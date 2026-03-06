import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/deck/domain/entities/deck.dart';
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/create_deck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  late CreateDeck usecase;
  late MockDeckRepository mockRepository;

  setUp(() {
    mockRepository = MockDeckRepository();
    usecase = CreateDeck(mockRepository);
  });

  final tDeck = Deck(
    id: '1',
    name: 'New Deck',
    description: 'A new deck',
    createdAt: DateTime(2024),
  );

  const tParams = CreateDeckParams(name: 'New Deck', description: 'A new deck');

  test('should return created deck from repository', () async {
    when(() => mockRepository.createDeck(any(), any()))
        .thenAnswer((_) async => Right(tDeck));

    final result = await usecase(tParams);

    expect(result, Right(tDeck));
    verify(() => mockRepository.createDeck('New Deck', 'A new deck')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure when repository fails', () async {
    const tFailure = CacheFailure('Cache error');
    when(() => mockRepository.createDeck(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParams);

    expect(result, const Left(tFailure));
    verify(() => mockRepository.createDeck('New Deck', 'A new deck')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
