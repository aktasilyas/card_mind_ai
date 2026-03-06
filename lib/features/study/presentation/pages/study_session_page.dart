import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/study_bloc.dart';
import '../widgets/flip_card_widget.dart';
import '../widgets/rating_bar_widget.dart';
import 'study_complete_page.dart';

class StudySessionPage extends StatelessWidget {
  const StudySessionPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudyBloc>()..add(LoadStudySession(deckId)),
      child: const _StudySessionView(),
    );
  }
}

class _StudySessionView extends StatelessWidget {
  const _StudySessionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Çalışma')),
      body: BlocConsumer<StudyBloc, StudyState>(
        listener: (context, state) {
          if (state is StudyComplete) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => StudyCompletePage(
                  totalCards: state.totalCards,
                  averageRating: state.averageRating,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            StudyInitial() || StudyLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            StudyEmpty() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Colors.green.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bugün çalışılacak kart yok!',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Geri Dön'),
                      ),
                    ],
                  ),
                ),
              ),
            StudyInProgress(:final session, :final isFlipped) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '${session.currentIndex + 1} / ${session.cards.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (session.currentIndex + 1) / session.cards.length,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 32),
                    FlipCardWidget(
                      key: ValueKey(session.currentIndex),
                      front: session.currentCard!.front,
                      back: session.currentCard!.back,
                      isFlipped: isFlipped,
                      onFlip: () =>
                          context.read<StudyBloc>().add(const FlipCard()),
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isFlipped
                          ? RatingBarWidget(
                              key: const ValueKey('rating'),
                              onRatingSelected: (quality) => context
                                  .read<StudyBloc>()
                                  .add(RateCard(quality)),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                  ],
                ),
              ),
            StudyError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Geri Dön'),
                    ),
                  ],
                ),
              ),
            StudyComplete() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
