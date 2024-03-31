import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// [PageModel] - This class contains the basic structure of the model.
/// PageModel need to initialize fields and dispose it. Add this, if your page is Stateful

abstract class PageModel {
  // A private variable `_isInitialized` to keep track of whether the model has been initialized or not.
  bool _isInitialized = false;

  /// An abstract method `initState` that initializes the model with required parameters and data sources.
  void initState(BuildContext context);

  /// A private method `_init` that calls the `initState` method only if the model is not already initialized.
  void _init(BuildContext context) {
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
  }

  /// A private variable `_disposeOnWidgetDisposal` set to true by default to dispose the model when corresponding widget is disposed.
  final bool _disposeOnWidgetDisposal = true;

  /// An abstract method `dispose` that disposes the resources used by the model.
  void dispose();

  /// A method `canDispose` that disposes the model only if `_disposeOnWidgetDisposal` is true.
  void canDispose() {
    if (_disposeOnWidgetDisposal) {
      dispose();
    }
  }

  /// A private variable `_updateOnChange` set to false by default to trigger update callbacks only when explicitly set to true.
  bool _updateOnChange = false;

  /// A private variable `_updateCallback` that holds the callback function called on update events.
  VoidCallback _updateCallback = () {};

  /// A method `onUpdate` that calls `_updateCallback` only if `_updateOnChange` is true.
  void onUpdate() => _updateOnChange ? _updateCallback() : () {};

  /// A method `setOnUpdate` sets `_updateCallback` and `_updateOnChange` with provided values and returns `this` for chaining purposes.
  PageModel setOnUpdate({
    required VoidCallback onUpdate,
    bool updateOnChange = false,
  }) =>
      this
        .._updateCallback = onUpdate
        .._updateOnChange = updateOnChange;

  /// A method `updatePage` that calls provided callback and `_updateCallback` in sequence.
  void updatePage(VoidCallback callback) {
    callback();
    _updateCallback();
  }
}

/// A function `createModel` that creates and initializes a new instance of specified model using the context and default builder function.
T createModel<T extends PageModel>(
  BuildContext context,
  T Function() defaultBuilder,
) {
  // Retrieves an existing instance of the model from the context or creates a new one using default builder function.
  final model = context.read<T?>() ?? defaultBuilder();

  // Initializes the model if not already initialized.
  model._init(context);

  // Returns the initialized model.
  return model;
}
