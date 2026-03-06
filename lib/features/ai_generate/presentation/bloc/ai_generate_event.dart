part of 'ai_generate_bloc.dart';

sealed class AiGenerateEvent {
  const AiGenerateEvent();
}

final class GenerateCards extends AiGenerateEvent {
  const GenerateCards({required this.text, required this.count});

  final String text;
  final int count;
}
