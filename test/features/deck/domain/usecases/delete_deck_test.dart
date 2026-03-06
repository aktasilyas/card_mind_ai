import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/delete_deck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  late DeleteDeck usecase;
  late MockDeckRepository mockRepository;

  setUp(() {
    mockRepository = MockDeckRepository();
    usecase = DeleteDeck(mockRepository);
  });

  const tParams = DeleteDeckParams(id: 'deck-1');

  test('should return Unit when deck is deleted successfully', () async {
    when(() => mockRepository.deleteDeck(any()))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(tParams);

    expect(result, const Right(unit));
    verify(() => mockRepository.deleteDeck('deck-1')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure when repository fails', () async {
    const tFailure = CacheFailure('Cache error');
    when(() => mockRepository.deleteDeck(any()))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParams);

    expect(result, const Left(tFailure));
    verify(() => mockRepository.deleteDeck('deck-1')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
