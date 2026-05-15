import 'package:shoppex/core/constants/app_string.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure({String message = AppStrings.noConnectionMessage})
      : super(message);
}