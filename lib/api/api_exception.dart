// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';

class ApiException implements Exception {
  final String? prefix;
  final String? message;
  final int? errorCode;

  ApiException({
    this.prefix,
    this.message,
    this.errorCode,
  });

  @override
  String toString() {
    Get.log('\x1B[91m[$prefix : ${errorCode ?? 0}] => $message\x1B[0m');
    return '$prefix $message';
  }
}

// Exception for bad requests
class BadRequestException extends ApiException {
  BadRequestException([String? message, int? errorCode])
      : super(prefix: 'Bad Request', message: message, errorCode: errorCode);
}

// Throw exception when failed to communicate with server
class FetchDataException extends ApiException {
  FetchDataException([String? message, int? errorCode])
      : super(
            prefix: 'Error During Communication',
            message: message,
            errorCode: errorCode);
}

// Throw exception for a timeout error
class TimeoutException extends ApiException {
  TimeoutException({super.message})
      : super(
          prefix: 'Timeout',
        );
}

// Exception for invalid input
class InvalidInputException extends ApiException {
  InvalidInputException({super.message})
      : super(
          prefix: 'Invalid Input',
        );
}

// Exception for unauthorized requests
class UnauthorizedException extends ApiException {
  UnauthorizedException([String? message, int? errorCode])
      : super(prefix: 'Unauthorized', message: message, errorCode: errorCode);
}
