import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../deck/domain/entities/flashcard.dart';
import '../../domain/usecases/generate_cards_from_text.dart';

part 'ai_generate_event.dart';
part 'ai_generate_state.dart';

@injectable
class AiGenerateBloc extends Bloc<AiGenerateEvent, AiGenerateState> {
  AiGenerateBloc(this._generateCardsFromText)
      : super(const AiGenerateInitial()) {
    on<GenerateCards>(_onGenerateCards);
    on<UpdateCardCount>(_onUpdateCardCount);
  }

  final GenerateCardsFromText _generateCardsFromText;

  void _onUpdateCardCount(
    UpdateCardCount event,
    Emitter<AiGenerateState> emit,
  ) {
    emit(AiGenerateInitial(cardCount: event.count));
  }

  Future<void> _onGenerateCards(
    GenerateCards event,
    Emitter<AiGenerateState> emit,
  ) async {
    final count = state.cardCount;
    emit(AiGenerateLoading(cardCount: count));
    final result = await _generateCardsFromText(
      GenerateCardsParams(text: event.text, count: count),
    );
    result.fold(
      (failure) {
        if (failure is LimitExceededFailure) {
          emit(AiGenerateLimitReached(cardCount: count));
        } else {
          emit(AiGenerateError(failure.message, cardCount: count));
        }
      },
      (generationResult) =>
          emit(AiGenerateSuccess(generationResult.generatedCards, cardCount: count)),
    );
  }
}
