import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

Either<Failure, T> handleException<T>(Exception exception) {
  if (exception is ServerException) {
    return Left(ServerFailure(
      message: exception.message,
      code: exception.code,
    ));
  } else if (exception is NetworkException) {
    return Left(NetworkFailure(
      message: exception.message,
      code: exception.code,
    ));
  } else if (exception is CacheException) {
    return Left(CacheFailure(
      message: exception.message,
      code: exception.code,
    ));
  } else if (exception is ConnectivityException) {
    return Left(ConnectivityFailure(
      message: exception.message,
      code: exception.code,
    ));
  } else {
    return Left(UnexpectedFailure(
      message: exception.toString(),
    ));
  }
}
