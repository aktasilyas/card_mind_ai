import '../../../deck/domain/entities/flashcard.dart';

class GenerationResult {
  const GenerationResult({
    required this.generatedCards,
    required this.inputText,
    required this.generatedAt,
  });

  final List<Flashcard> generatedCards;
  final String inputText;
  final DateTime generatedAt;
}
