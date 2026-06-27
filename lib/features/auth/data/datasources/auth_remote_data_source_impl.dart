import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/data/models/user_model.dart';
import 'package:ledge/utils/constants.dart';

const kCreateUserEndpoint = '/users';
const kGetUsersEndpoint = '/users';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._httpClient);

  final http.Client _httpClient;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    /// For TDD for remote data source impl:
    /// 1) Check to make sure it returns the right data when the status code is 200 or success status code
    /// 2) Check to make sure it [Throws a Custom Exception] with right message when status code is bad
      final res = await _httpClient.post(
        Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
      );

      if(res.statusCode != 200 && res.statusCode != 201) {
        throw ServerException(message: res.body, statusCode: res.statusCode);
      }

  }

  @override
  Future<List<UserModel>> getUsers() async {
    throw UnimplementedError();
  }
}
