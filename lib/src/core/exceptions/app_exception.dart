// ignore_for_file: no_runtimetype_tostring

import 'package:equatable/equatable.dart';

part 'invalid_data_format.dart';
part 'no_data_exception.dart';

sealed class AppException extends Equatable implements Exception {
  const AppException([this.debugMessage]);

  final Object? debugMessage;

  @override
  List<Object?> get props => [debugMessage];

  @override
  String toString() {
    var output = runtimeType.toString();
    if (debugMessage != null) output += ': $debugMessage';
    return output;
  }
}
