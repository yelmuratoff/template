import 'package:base_starter/src/core/theme/domain/theme_colors.dart';
import 'package:base_starter/src/core/theme/domain/theme_text_styles.dart';
import 'package:base_starter/src/core/theme/presentation/theme_colors.dart';
import 'package:base_starter/src/core/theme/presentation/themes/light.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/initialization/presentation/dependencies_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/octopus.dart';
import 'package:provider/provider.dart';

/// List of extensions for `BuildContext`
extension ContextExtension on BuildContext {
  /// `pop` pops the current `BuildContext` from the `Navigator`.
  void pop() {
    octopus.pop();
    if (Navigator.canPop(this)) {
      Navigator.maybePop(this);
      return;
    }
  }

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete `InheritedWidget` subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T? inhMaybeOf<T extends InheritedWidget>({bool listen = true}) => listen
      ? dependOnInheritedWidgetOfExactType<T>()
      : getInheritedWidgetOfExactType<T>();

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete `InheritedWidget` subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T inhOf<T extends InheritedWidget>({bool listen = true}) =>
      inhMaybeOf<T>(listen: listen) ??
      (throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a $T of the exact type',
        'out_of_scope',
      ));

  /// Maybe inherit specific aspect from `InheritedModel`.
  T? maybeInheritFrom<A extends Object, T extends InheritedModel<A>>(
    A? aspect,
  ) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect);

  /// Inherit specific aspect from `InheritedModel`.
  T inheritFrom<A extends Object, T extends InheritedModel<A>>({A? aspect}) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect) ??
      (throw ArgumentError(
        'Out of scope, not found inherited model '
            'a $T of the exact type',
        'out_of_scope',
      ));

  /// `size` returns the current `MediaQuery` size of the `BuildContext`.
  Size get mediaSize => MediaQuery.sizeOf(this);

  /// `viewInsets` returns the current `MediaQuery`
  /// view insets of the `BuildContext`.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// `height` returns the height of the current `MediaQuery`.
  double get height => MediaQuery.sizeOf(this).height;

  /// `width` returns the width of the current `MediaQuery`.
  double get width => MediaQuery.sizeOf(this).width;

  /// `theme` returns the current `ThemeData` of the `BuildContext`.
  ThemeData get theme => Theme.of(this);

  /// `colors` returns colors of the `BuildContext`.
  IColors get colors => theme.extension<IColors>()!;

  /// `textStyles` returns text styles of the `BuildContext`.
  ITextStyles get textStyles =>
      theme.extension<ITextStyles>() ?? LightThemeData.textStyles;

  /// `isDark` returns `true` if the current `Theme` is dark.
  bool get isDark => theme.brightness == Brightness.dark;

  /// `isLight` returns `true` if the current `Theme` is light.
  bool get isLight => theme.brightness == Brightness.light;

  /// `isAndroid` returns `true` if the current `Theme` is for Android.
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;

  /// `isIOS` returns `true` if the current `Theme` is for iOS.
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;

  /// `isFuchsia` returns `true` if the current `Theme` is for Fuchsia.
  bool get isFuchsia => Theme.of(this).platform == TargetPlatform.fuchsia;

  /// `isMacOS` returns `true` if the current `Theme` is for macOS.
  bool get isMacOS => Theme.of(this).platform == TargetPlatform.macOS;

  /// `isLinux` returns `true` if the current `Theme` is for Linux.
  bool get isLinux => Theme.of(this).platform == TargetPlatform.linux;

  /// `isWindows` returns `true` if the current `Theme` is for Windows.
  bool get isWindows => Theme.of(this).platform == TargetPlatform.windows;

  /// `isWeb` returns `true` if the current `Platform` is for Web.
  bool get isWeb => kIsWeb;

  /// `dependencies` returns the nearest `DependenciesScope`
  /// of the given `BuildContext`.
  DependenciesContainer get dependencies => DependenciesScope.of(this);

  /// `provide` returns the nearest `Provider` of the given `BuildContext`.
  T provide<T>() => Provider.of<T>(this);

  /// `blocProvide` returns the nearest `BlocProvider` of the
  /// given `BuildContext`.
  T blocWatch<T extends StateStreamableSource<Object?>>() =>
      BlocProvider.of<T>(this, listen: true);

  /// `provideOnce` returns the nearest `Provider` of the given `BuildContext`
  /// without listening to changes.
  T provideOnce<T>() => Provider.of<T>(this, listen: false);

  T blocRead<T extends StateStreamableSource<Object?>>() =>
      BlocProvider.of<T>(this);

  /// `provideOrNull` returns the nearest `Provider` of the given `BuildContext`
  /// or `null` if not found.
  T? provideOrNull<T>() {
    try {
      return provide<T>();
    } catch (error) {
      return null;
    }
  }

  /// `provideOnceOrNull` returns the nearest `Provider` of the given
  /// `BuildContext` without listening to changes or `null` if not found.
  T? provideOnceOrNull<T>() {
    try {
      return provideOnce<T>();
    } catch (error) {
      return null;
    }
  }
}

/// List of extensions for `ThemeData`
extension ColorsThemeData on ThemeData {
  /// `colors` returns colors of the `ThemeData`.
  ThemeColors get colors => extension<ThemeColors>()!;
}
