import 'package:flutter/material.dart';

class AppSettings {
  final int dailyGoal;
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;
  final ThemeMode themeMode;

  const AppSettings({
    this.dailyGoal = 20,
    this.notificationsEnabled = false,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.themeMode = ThemeMode.dark,
  });

  AppSettings copyWith({
    int? dailyGoal,
    bool? notificationsEnabled,
    int? notificationHour,
    int? notificationMinute,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
