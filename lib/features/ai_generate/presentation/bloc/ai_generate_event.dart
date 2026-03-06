part of 'ai_generate_bloc.dart';

sealed class AiGenerateEvent {
  const AiGenerateEvent();
}

final class GenerateCards extends AiGenerateEvent {
  const GenerateCards({required this.text});

  final String text;
}

final class UpdateCardCount extends AiGenerateEvent {
  const UpdateCardCount(this.count);

  final int count;
}
