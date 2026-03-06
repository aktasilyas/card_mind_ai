import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/deck/domain/entities/flashcard.dart';
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/get_due_cards.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  late GetDueCards useCase;
  late MockDeckRepository mockRepository;

  setUp(() {
    mockRepository = MockDeckRepository();
    useCase = GetDueCards(mockRepository);
  });

  final tCards = [
    Flashcard(
      id: '1',
      deckId: 'deck1',
      front: 'Soru 1',
      back: 'Cevap 1',
      dueDate: DateTime(2024),
    ),
  ];

  test('should return due cards from the repository', () async {
    when(() => mockRepository.getDueCards('deck1'))
        .thenAnswer((_) async => Right(tCards));

    final result = await useCase(const GetDueCardsParams(deckId: 'deck1'));

    expect(result, Right(tCards));
    verify(() => mockRepository.getDueCards('deck1')).called(1);
  });

  test('should return failure when repository fails', () async {
    when(() => mockRepository.getDueCards('deck1'))
        .thenAnswer((_) async => const Left(CacheFailure('Hata')));

    final result = await useCase(const GetDueCardsParams(deckId: 'deck1'));

    expect(result, const Left(CacheFailure('Hata')));
  });
}
