import 'package:equatable/equatable.dart';

class User extends Equatable { /// this defines the blueprint of the object that will collect the data in this case user data that comes from server
  /// this is going to be a blueprint so we dont need to test this
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
