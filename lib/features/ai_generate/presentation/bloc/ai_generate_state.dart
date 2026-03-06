part of 'ai_generate_bloc.dart';

sealed class AiGenerateState {
  const AiGenerateState({this.cardCount = 5});

  final int cardCount;
}

final class AiGenerateInitial extends AiGenerateState {
  const AiGenerateInitial({super.cardCount});
}

final class AiGenerateLoading extends AiGenerateState {
  const AiGenerateLoading({super.cardCount});
}

final class AiGenerateSuccess extends AiGenerateState {
  const AiGenerateSuccess(this.cards, {super.cardCount});

  final List<Flashcard> cards;
}

final class AiGenerateError extends AiGenerateState {
  const AiGenerateError(this.message, {super.cardCount});

  final String message;
}

final class AiGenerateLimitReached extends AiGenerateState {
  const AiGenerateLimitReached({super.cardCount});
}
