import 'package:equatable/equatable.dart';

class User extends Equatable {
  /// this defines the blueprint of the object that will collect the data in this case user data that comes from server
  /// this is going to be a blueprint so we dont need to test this
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  /// this we are creating for reusability for testing and other for not passing the empty params again and again
  const User.empty()
    : this(
        id: '1',
        createdAt: '_empty.createdAt',
        name: '_empty.name',
        avatar: '_empty.avatar',
      );

  final String id;
  final String createdAt;
  final String name;
  final String avatar;
  // creating variables based on api response

  @override
  List<Object?> get props => [id]; // using equatable to validate if user id is same or not
}
