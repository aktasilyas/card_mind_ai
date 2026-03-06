import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/sm2_algorithm.dart';
import '../../../deck/domain/usecases/get_due_cards.dart';
import '../../../deck/domain/usecases/update_card.dart';
import '../../domain/entities/study.dart';

part 'study_event.dart';
part 'study_state.dart';

@injectable
class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc(this._getDueCards, this._updateCard)
      : super(const StudyInitial()) {
    on<LoadStudySession>(_onLoadStudySession);
    on<FlipCard>(_onFlipCard);
    on<RateCard>(_onRateCard);
  }

  final GetDueCards _getDueCards;
  final UpdateCard _updateCard;

  Future<void> _onLoadStudySession(
    LoadStudySession event,
    Emitter<StudyState> emit,
  ) async {
    emit(const StudyLoading());
    final result = await _getDueCards(
      GetDueCardsParams(deckId: event.deckId),
    );
    result.fold(
      (failure) => emit(StudyError(failure.message)),
      (cards) {
        if (cards.isEmpty) {
          emit(const StudyEmpty());
        } else {
          emit(StudyInProgress(
            session: StudySession(deckId: event.deckId, cards: cards),
          ));
        }
      },
    );
  }

  void _onFlipCard(FlipCard event, Emitter<StudyState> emit) {
    final current = state;
    if (current is StudyInProgress) {
      emit(StudyInProgress(
        session: current.session,
        isFlipped: !current.isFlipped,
      ));
    }
  }

  Future<void> _onRateCard(
    RateCard event,
    Emitter<StudyState> emit,
  ) async {
    final current = state;
    if (current is! StudyInProgress) return;

    final card = current.session.currentCard;
    if (card == null) return;

    final sm2Result = SM2Algorithm.calculate(
      quality: event.quality,
      easeFactor: card.easeFactor,
      interval: card.interval,
      repetitions: card.repetitions,
    );

    final updatedCard = card.copyWith(
      easeFactor: sm2Result.newEaseFactor,
      interval: sm2Result.nextInterval,
      repetitions: sm2Result.newRepetitions,
      dueDate: sm2Result.nextReviewDate,
    );

    final updateResult = await _updateCard(updatedCard);
    if (updateResult.isLeft()) {
      updateResult.fold(
        (failure) => emit(StudyError(failure.message)),
        (_) {},
      );
      return;
    }

    final newRatings = [...current.session.ratings, event.quality];
    final nextIndex = current.session.currentIndex + 1;

    if (nextIndex >= current.session.cards.length) {
      final avgRating = newRatings.reduce((a, b) => a + b) / newRatings.length;
      emit(StudyComplete(
        totalCards: current.session.cards.length,
        averageRating: avgRating,
      ));
    } else {
      emit(StudyInProgress(
        session: current.session.copyWith(
          currentIndex: nextIndex,
          ratings: newRatings,
        ),
      ));
    }
  }
}
