import 'failure.dart';

class ServerFailure implements Exception {
  final Failure errorModel;

  ServerFailure(this.errorModel);
  @override
  String toString() {
    return errorModel.errorMessage;
  }
}

class BadCertificateException extends ServerFailure {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerFailure {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerFailure {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerFailure {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerFailure {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerFailure {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerFailure {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerFailure {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerFailure {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerFailure {
  CofficientException(super.errorModel);
}

class CancelException extends ServerFailure {
  CancelException(super.errorModel);
}

class UnknownException extends ServerFailure {
  UnknownException(super.errorModel);
}
