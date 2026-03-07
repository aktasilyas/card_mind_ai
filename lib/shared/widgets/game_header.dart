import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/stats/presentation/bloc/stats_bloc.dart';
import '../../l10n/app_localizations.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        final streak = state is StatsLoaded ? state.userStats.currentStreak : 0;
        final xp = state is StatsLoaded ? state.userStats.totalXp : 0;
        final level = state is StatsLoaded ? state.userStats.level : 1;
        final hearts =
            state is StatsLoaded ? state.userStats.heartsRemaining : 5;
        final levelProgress =
            state is StatsLoaded ? state.userStats.levelProgress : 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                _StreakBadge(streak: streak),
                const SizedBox(width: 12),
                Expanded(
                  child: _XpProgressBar(
                    xp: xp,
                    level: level,
                    progress: levelProgress,
                  ),
                ),
                const SizedBox(width: 12),
                _HeartsBadge(hearts: hearts),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '\u{1F525}',
          style: TextStyle(fontSize: streak > 0 ? 20 : 16),
        ),
        const SizedBox(width: 4),
        Text(
          '$streak',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: streak > 0
                ? const Color(0xFFFF9600)
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  const _XpProgressBar({
    required this.xp,
    required this.level,
    required this.progress,
  });

  final int xp;
  final int level;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.levelLabel(level),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$xp XP',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.1),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
          ),
        ),
      ],
    );
  }
}

class _HeartsBadge extends StatelessWidget {
  const _HeartsBadge({required this.hearts});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite,
          size: 20,
          color: hearts > 0
              ? const Color(0xFFFF4B4B)
              : Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
        ),
        const SizedBox(width: 4),
        Text(
          '$hearts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: hearts > 0
                ? const Color(0xFFFF4B4B)
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
