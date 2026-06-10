import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledge/features/auth/data/models/user_model.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/utils/typedef.dart';
import '../../../../fixtures/fixture_reader.dart';

/* Questions to ask
 Q1 What does the class depend on - nothing
*/

const tModel = UserModel.empty();

void main() {
  // 1st test for model
  test('Should be a subclass of [User] entity', () {
    /// Arrange - tModel
    /// Act - in this case we have nothing to act upon
    /// Assert -
    expect(tModel, isA<User>());
  });

  // now we will test fromMap as a group
  /// Arrange
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('Should return a [UserModel] with correct map data', () {
      /// Act
      final res = UserModel.fromMap(tMap);

      /// Assert
      expect(res, equals(tModel));
    });
  });

  // now test for fromJson as a group
  group('fromJson', () {
    test('Should return a [UserModel] with correct json data', () {
      /// Act
      final res = UserModel.fromJson(tJson);

      /// Assert
      expect(res, equals(tModel));
    });
  });

  // now test for toMap as a group
  group('toMap', () {
    test('Should return a [DataMap] with map correct data', () {
      /// Act
      final res = tModel.toMap();

      /// Assert
      expect(res, equals(tMap));
    });
  });

  // now test for toJson as a group
  group('toJson', () {
    test('Should return a [JSON] with correct json data', () {
      /// Act
      final res = tModel.toJson();
      final tJson = jsonEncode({
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar",
        "id": "1",
      });

      /// Assert
      expect(res, equals(tJson));
    });
  });

  // now test for copyWith as a group
  group('copyWith', () {
    test('Should always return [UserModel] with changed data', () {
      /// Act
      final res = tModel.copyWith(name: 'Suraj', id: '2', createdAt: '12:30 pm', avatar: 'test_avatar');

      /// Assert
      expect(res.name, equals('Suraj'));
      expect(res.avatar, equals('test_avatar'));
      expect(res.id, equals('2'));
      expect(res.createdAt, equals('12:30 pm'));
      // expect(res, equals(tModel));
    });
  });
}
