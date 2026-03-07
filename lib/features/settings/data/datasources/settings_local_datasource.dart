import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDatasource {
  Future<AppSettings> getSettings();
  Future<AppSettings> saveSettings(AppSettings settings);
}

class _Keys {
  static const dailyGoal = 'settings_daily_goal';
  static const notificationsEnabled = 'settings_notifications_enabled';
  static const notificationHour = 'settings_notification_hour';
  static const notificationMinute = 'settings_notification_minute';
  static const themeMode = 'settings_theme_mode';
  static const locale = 'settings_locale';
}

@LazySingleton(as: SettingsLocalDatasource)
class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  final SharedPreferences _prefs;

  const SettingsLocalDatasourceImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    try {
      final themeModeIndex = _prefs.getInt(_Keys.themeMode) ?? ThemeMode.dark.index;
      return AppSettings(
        dailyGoal: _prefs.getInt(_Keys.dailyGoal) ?? 20,
        notificationsEnabled:
            _prefs.getBool(_Keys.notificationsEnabled) ?? false,
        notificationHour: _prefs.getInt(_Keys.notificationHour) ?? 9,
        notificationMinute: _prefs.getInt(_Keys.notificationMinute) ?? 0,
        themeMode: ThemeMode.values[themeModeIndex],
        locale: _prefs.getString(_Keys.locale) ?? 'tr',
      );
    } catch (e) {
      throw CacheException(message: 'Failed to load settings: $e');
    }
  }

  @override
  Future<AppSettings> saveSettings(AppSettings settings) async {
    try {
      await Future.wait([
        _prefs.setInt(_Keys.dailyGoal, settings.dailyGoal),
        _prefs.setBool(
            _Keys.notificationsEnabled, settings.notificationsEnabled),
        _prefs.setInt(_Keys.notificationHour, settings.notificationHour),
        _prefs.setInt(_Keys.notificationMinute, settings.notificationMinute),
        _prefs.setInt(_Keys.themeMode, settings.themeMode.index),
        _prefs.setString(_Keys.locale, settings.locale),
      ]);
      return settings;
    } catch (e) {
      throw CacheException(message: 'Failed to save settings: $e');
    }
  }
}
