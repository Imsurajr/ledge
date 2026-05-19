import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });
  final int id;
  final String createdAt;
  final String name;
  final String avatar;
  // creating variables based on api response

  @override
  List<Object?> get props => [id]; // using equatable to validate if user id is same or not
}
