import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../subscription/domain/entities/subscription_status.dart';
import '../../../subscription/presentation/bloc/subscription_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>().add(const LoadSettings());
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: false,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! SettingsLoaded) return const SizedBox.shrink();

          final settings = state.settings;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const _SectionHeader(title: 'Calisma'),
              _DailyGoalTile(currentGoal: settings.dailyGoal),
              const _SectionHeader(title: 'Bildirimler'),
              _NotificationTile(
                enabled: settings.notificationsEnabled,
                hour: settings.notificationHour,
                minute: settings.notificationMinute,
              ),
              const _SectionHeader(title: 'Gorunum'),
              _ThemeTile(current: settings.themeMode),
              const _SectionHeader(title: 'Abonelik'),
              const _SubscriptionTile(),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _DailyGoalTile extends StatelessWidget {
  final int currentGoal;
  const _DailyGoalTile({required this.currentGoal});

  static const _goals = [5, 10, 15, 20, 30, 50];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.flag_rounded),
      title: const Text('Gunluk Hedef'),
      subtitle: Text('$currentGoal kart/gun'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showGoalSheet(context),
    );
  }

  void _showGoalSheet(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Gunluk Hedef',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ..._goals.map(
              (goal) => ListTile(
                leading: Icon(
                  goal == currentGoal
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: goal == currentGoal
                      ? Theme.of(ctx).colorScheme.primary
                      : null,
                ),
                title: Text('$goal kart/gun'),
                onTap: () {
                  bloc.add(UpdateDailyGoal(goal));
                  Navigator.pop(ctx);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final bool enabled;
  final int hour;
  final int minute;

  const _NotificationTile({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return ListTile(
      leading: const Icon(Icons.notifications_rounded),
      title: const Text('Gunluk Hatirlatma'),
      subtitle: Text(enabled ? 'Acik — $timeStr' : 'Kapali'),
      trailing: Switch(
        value: enabled,
        onChanged: (val) => _onToggle(context, val),
      ),
      onTap: enabled ? () => _showTimePicker(context) : null,
    );
  }

  Future<void> _onToggle(BuildContext context, bool val) async {
    final bloc = context.read<SettingsBloc>();
    final notificationService = getIt<NotificationService>();
    if (val) {
      final granted = await notificationService.requestPermission();
      if (!granted || !context.mounted) return;
      await notificationService.scheduleDailyReminder(
          hour: hour, minute: minute);
    } else {
      await notificationService.cancelAll();
    }
    if (context.mounted) {
      bloc.add(UpdateNotification(
            enabled: val,
            hour: hour,
            minute: minute,
          ));
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked == null || !context.mounted) return;
    await getIt<NotificationService>().scheduleDailyReminder(
      hour: picked.hour,
      minute: picked.minute,
    );
    if (context.mounted) {
      context.read<SettingsBloc>().add(UpdateNotification(
            enabled: true,
            hour: picked.hour,
            minute: picked.minute,
          ));
    }
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeMode current;
  const _ThemeTile({required this.current});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette_rounded),
      title: const Text('Tema'),
      subtitle: Text(_label(current)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeSheet(context),
    );
  }

  String _label(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Acik',
        ThemeMode.dark => 'Koyu',
        ThemeMode.system => 'Sistem',
      };

  void _showThemeSheet(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Tema',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...ThemeMode.values.map(
              (mode) => ListTile(
                leading: Icon(
                  mode == current
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: mode == current
                      ? Theme.of(ctx).colorScheme.primary
                      : null,
                ),
                title: Text(_label(mode)),
                onTap: () {
                  bloc.add(UpdateThemeMode(mode));
                  Navigator.pop(ctx);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        final isPremium = state is SubscriptionLoaded &&
            state.status.tier == SubscriptionTier.premium;
        return ListTile(
          leading: Icon(
            isPremium ? Icons.workspace_premium : Icons.lock_open_rounded,
            color: isPremium ? Colors.amber : null,
          ),
          title: Text(isPremium ? 'CardMind Premium' : 'Premium\'a Gec'),
          subtitle: Text(isPremium
              ? 'Aktif — Tum ozellikler acik'
              : 'PDF, sesli giris ve daha fazlasi'),
          trailing: isPremium ? null : const Icon(Icons.chevron_right),
          onTap: isPremium ? null : () => _openPaywall(context),
        );
      },
    );
  }

  void _openPaywall(BuildContext context) {
    context.read<SubscriptionBloc>().add(const PurchasePremiumEvent());
  }
}
