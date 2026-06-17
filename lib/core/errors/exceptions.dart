import 'package:equatable/equatable.dart';

class ServerFailure extends Equatable implements Exception {
  const ServerFailure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
