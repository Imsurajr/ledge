import 'package:equatable/equatable.dart';

/// we will now define a Server Failure which is extending equatable for comparison with Exceptions threw
/// by server and will be implementing Exception again to handle Server's threw Exceptions

class ServerFailure extends Equatable implements Exception {
  const ServerFailure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
  /// Making sure both message and statusCode matches to throw a Server exception
}
