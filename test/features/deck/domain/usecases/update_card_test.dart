import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/deck/domain/entities/flashcard.dart';
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart';
import 'package:card_mind_ai/features/deck/domain/usecases/update_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  late UpdateCard useCase;
  late MockDeckRepository mockRepository;

  setUp(() {
    mockRepository = MockDeckRepository();
    useCase = UpdateCard(mockRepository);
  });

  final tCard = Flashcard(
    id: '1',
    deckId: 'deck1',
    front: 'Soru',
    back: 'Cevap',
    dueDate: DateTime(2024),
  );

  setUpAll(() {
    registerFallbackValue(tCard);
  });

  test('should return unit on successful update', () async {
    when(() => mockRepository.updateCard(any()))
        .thenAnswer((_) async => const Right(unit));

    final result = await useCase(tCard);

    expect(result, const Right(unit));
    verify(() => mockRepository.updateCard(tCard)).called(1);
  });

  test('should return failure when update fails', () async {
    when(() => mockRepository.updateCard(any()))
        .thenAnswer((_) async => const Left(CacheFailure('Güncelleme hatası')));

    final result = await useCase(tCard);

    expect(result, const Left(CacheFailure('Güncelleme hatası')));
  });
}
