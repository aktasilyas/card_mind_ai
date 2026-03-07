import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings _getSettings;
  final UpdateSettings _updateSettings;

  SettingsBloc(this._getSettings, this._updateSettings)
      : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoad);
    on<UpdateDailyGoal>(_onUpdateDailyGoal);
    on<UpdateNotification>(_onUpdateNotification);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateLocale>(_onUpdateLocale);
  }

  AppSettings get _current =>
      state is SettingsLoaded ? (state as SettingsLoaded).settings : const AppSettings();

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());
    final result = await _getSettings();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateDailyGoal(
      UpdateDailyGoal event, Emitter<SettingsState> emit) async {
    final updated = _current.copyWith(dailyGoal: event.goal);
    await _save(updated, emit);
  }

  Future<void> _onUpdateNotification(
      UpdateNotification event, Emitter<SettingsState> emit) async {
    final updated = _current.copyWith(
      notificationsEnabled: event.enabled,
      notificationHour: event.hour,
      notificationMinute: event.minute,
    );
    await _save(updated, emit);
  }

  Future<void> _onUpdateThemeMode(
      UpdateThemeMode event, Emitter<SettingsState> emit) async {
    final updated = _current.copyWith(themeMode: event.themeMode);
    await _save(updated, emit);
  }

  Future<void> _onUpdateLocale(
      UpdateLocale event, Emitter<SettingsState> emit) async {
    final updated = _current.copyWith(locale: event.locale);
    await _save(updated, emit);
  }

  Future<void> _save(AppSettings settings, Emitter<SettingsState> emit) async {
    final result = await _updateSettings(settings);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (saved) => emit(SettingsLoaded(saved)),
    );
  }
}
