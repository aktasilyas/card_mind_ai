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
  }

  final GenerateCardsFromText _generateCardsFromText;

  Future<void> _onGenerateCards(
    GenerateCards event,
    Emitter<AiGenerateState> emit,
  ) async {
    emit(const AiGenerateLoading());
    final result = await _generateCardsFromText(
      GenerateCardsParams(text: event.text, count: event.count),
    );
    result.fold(
      (failure) {
        if (failure is LimitExceededFailure) {
          emit(const AiGenerateLimitReached());
        } else {
          emit(AiGenerateError(failure.message));
        }
      },
      (generationResult) =>
          emit(AiGenerateSuccess(generationResult.generatedCards)),
    );
  }
}
