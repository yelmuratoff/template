part of 'app_exception.dart';

class NoDataException extends AppException {
  const NoDataException([super.debugMessage]);

  @override
  String toString() {
    final debugMessage = super.debugMessage as String?;
    if (debugMessage != null) {
      return 'No Data Found!\nMessage: $debugMessage';
    } else {
      return 'No Data Found!';
    }
  }
}
