import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/debug/app_logger.dart';
import '../core/storage/app_storage.dart';

final class AppState {
  const AppState({this.locale, this.themeMode = ThemeMode.system});

  final Locale? locale;
  final ThemeMode themeMode;

  AppState copyWith({Locale? locale, ThemeMode? themeMode}) => AppState(
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
  );
}

final class AppCubit extends Cubit<AppState> {
  AppCubit(this._storage) : super(const AppState());

  final AppStorage _storage;

  Future<void> load() async {
    final languageCode = await _storage.read('preferred_locale');
    final theme = await _storage.read('theme_mode');
    emit(
      AppState(
        locale: languageCode == null ? null : Locale(languageCode),
        themeMode: ThemeMode.values.firstWhere(
          (value) => value.name == theme,
          orElse: () => ThemeMode.system,
        ),
      ),
    );
    AppLogger.info('LOCALIZATION', 'Saved app preferences loaded');
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.write('preferred_locale', locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.write('theme_mode', mode.name);
    emit(state.copyWith(themeMode: mode));
  }
}
