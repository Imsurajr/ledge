import 'package:dartz/dartz.dart';
import 'package:ledge/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;