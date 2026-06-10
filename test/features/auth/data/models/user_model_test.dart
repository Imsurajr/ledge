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
    test('Should return a [UserModel] with correct data', () {
      /// Act
      final res = UserModel.fromMap(tMap);
      expect(res, equals(tModel));
    });
  });

  // now test for toMap as a group
  group('fromJson', () {
    test('Should return a [UserModel] with correct data', () {
      /// Act
      final res = UserModel.fromJson(tJson);
      expect(res, equals(tModel));
    });
  });
}
