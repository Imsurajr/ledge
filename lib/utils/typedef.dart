import 'package:dartz/dartz.dart';
import 'package:ledge/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>; // creating a typedef with type Future with type of Either a Failure or T which is user defined data type
typedef ResultVoid = ResultFuture<void>; // customizing ResultFuture for user defined data type of void