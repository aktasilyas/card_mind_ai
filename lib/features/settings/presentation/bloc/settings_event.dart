part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

final class UpdateDailyGoal extends SettingsEvent {
  const UpdateDailyGoal(this.goal);

  final int goal;
}

final class UpdateNotification extends SettingsEvent {
  const UpdateNotification({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int hour;
  final int minute;
}

final class UpdateThemeMode extends SettingsEvent {
  const UpdateThemeMode(this.themeMode);

  final ThemeMode themeMode;
}
