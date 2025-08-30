import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'app_view_model.g.dart';

class AppViewModel = _AppViewModelBase with _$AppViewModel;

abstract class _AppViewModelBase with Store {
  final prefs = GetIt.I.get<Prefs>();

  @computed
  ThemeMode get themeMode => ThemeMode.values[prefs.themeMode ?? 0];
}
