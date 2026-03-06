part of 'ai_generate_bloc.dart';

sealed class AiGenerateState {
  const AiGenerateState();
}

final class AiGenerateInitial extends AiGenerateState {
  const AiGenerateInitial();
}

final class AiGenerateLoading extends AiGenerateState {
  const AiGenerateLoading();
}

final class AiGenerateSuccess extends AiGenerateState {
  const AiGenerateSuccess(this.cards);

  final List<Flashcard> cards;
}

final class AiGenerateError extends AiGenerateState {
  const AiGenerateError(this.message);

  final String message;
}

final class AiGenerateLimitReached extends AiGenerateState {
  const AiGenerateLimitReached();
}
