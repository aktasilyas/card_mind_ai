import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/study_session_record.dart';
import '../bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Istatistikler')),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return switch (state) {
            StatsInitial() || StatsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            StatsError(:final message) => Center(child: Text(message)),
            StatsLoaded(:final userStats, :final weeklyRecords) =>
              RefreshIndicator(
                onRefresh: () async {
                  context.read<StatsBloc>().add(const RefreshStats());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _DailyGoalRing(
                      current: userStats.todayStudiedCount,
                      goal: userStats.dailyGoal,
                    ),
                    const SizedBox(height: 24),
                    _WeeklyChart(records: weeklyRecords),
                    const SizedBox(height: 24),
                    _StatsGrid(
                      totalXp: userStats.totalXp,
                      streak: userStats.currentStreak,
                      accuracy: userStats.accuracy,
                      totalCards: userStats.totalCardsStudied,
                    ),
                    const SizedBox(height: 24),
                    _AchievementsGrid(
                      achievements: userStats.achievements,
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

class _DailyGoalRing extends StatelessWidget {
  const _DailyGoalRing({required this.current, required this.goal});

  final int current;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : (current / goal).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Gunluk Hedef',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0
                            ? const Color(0xFF58CC02)
                            : const Color(0xFF1CB0F6),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$current',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/ $goal kart',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.records});

  final List<StudySessionRecord> records;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayLabels = ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'];
    final dailyXp = List.filled(7, 0);

    for (final record in records) {
      final diff = now.difference(record.date).inDays;
      if (diff < 7) {
        final dayIndex = record.date.weekday - 1;
        dailyXp[dayIndex] += record.xpEarned;
      }
    }

    final maxY = dailyXp.reduce((a, b) => a > b ? a : b).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Haftalik XP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY == 0 ? 100 : maxY * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= dayLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dayLabels[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dailyXp[index].toDouble(),
                          color: const Color(0xFF58CC02),
                          width: 24,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.totalXp,
    required this.streak,
    required this.accuracy,
    required this.totalCards,
  });

  final int totalXp;
  final int streak;
  final double accuracy;
  final int totalCards;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: Icons.bolt,
          label: 'Toplam XP',
          value: '$totalXp',
          color: const Color(0xFFFF9600),
        ),
        _StatCard(
          icon: Icons.local_fire_department,
          label: 'Seri',
          value: '$streak gun',
          color: const Color(0xFFFF9600),
        ),
        _StatCard(
          icon: Icons.gps_fixed,
          label: 'Basari',
          value: '${accuracy.toStringAsFixed(0)}%',
          color: const Color(0xFF58CC02),
        ),
        _StatCard(
          icon: Icons.style,
          label: 'Toplam Kart',
          value: '$totalCards',
          color: const Color(0xFF1CB0F6),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
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
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  const _AchievementsGrid({required this.achievements});

  final List<String> achievements;

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Henuz rozet kazanilmadi.\nCalismaya devam et!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rozetler',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: achievements
                  .map((a) => Chip(label: Text(a)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
