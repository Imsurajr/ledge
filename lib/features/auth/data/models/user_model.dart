import 'dart:convert';

import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/utils/typedef.dart';

/*
    first we are supposed to extend the equity then we are supposed to call parameters through super extended class
    then we are supposed to write from/to json methods or from/to map
 */
// A data model for [User] that handles JSON serialization and deserialization.
class UserModel extends User {
  const UserModel({
    required super.avatar,
    required super.createdAt,
    required super.id,
    required super.name,
  });

  // an empty constructor to avoid creating object of class with same data
  const UserModel.empty()
    : this(
        id: '1',
        createdAt: '_empty.createdAt',
        name: '_empty.name',
        avatar: '_empty.avatar',
      );

  // we will be using this copyWith to update any information in the UserModel
  UserModel copyWith({
    String? createdAt,
    String? name,
    String? id,
    String? avatar,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
    );
  }

  // Constructs a [UserModel] from a JSON string by delegating to [fromMap], decode data that comes in json format and pass it as Map
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  // Constructs a [UserModel] from a raw key-value map.
  UserModel.fromMap(DataMap map)
    : this(
        createdAt: map['createdAt'] as String,
        avatar: map['avatar'] as String,
        name: map['name'] as String,
        id: map['id'] as String,
      );

  // Converts this [UserModel] to a [DataMap].
  DataMap toMap() => {
    'createdAt': createdAt,
    'name': name,
    'avatar': avatar,
    'id': id,
  };

  // Serializes this [UserModel] to a JSON string.
  String toJson() => jsonEncode(toMap());
}
