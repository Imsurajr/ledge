import 'package:equatable/equatable.dart';
import 'package:ledge/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});
  final String message;
  final int statusCode;

  String get errorMessage =>
      '$statusCode'
      'Error: '
      '$message';

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  /// creating a reusable constructor for handling server error
  ServerFailure.fromException(ServerException e)
    : this(message: e.message, statusCode: e.statusCode);
}
