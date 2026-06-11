part of 'app_exception.dart';

class InvalidDataException extends AppException {
  const InvalidDataException([super.debugMessage]);

  @override
  String toString() {
    final debugMessage = super.debugMessage as String?;
    if (debugMessage != null) {
      return 'Invalid Data Format!\nMessage: $debugMessage';
    } else {
      return 'Invalid Data Format!';
    }
  }
}
