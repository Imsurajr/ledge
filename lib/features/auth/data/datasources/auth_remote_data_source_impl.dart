import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/data/models/user_model.dart';
import 'package:ledge/utils/constants.dart';
import 'package:ledge/utils/typedef.dart';

const kCreateUserEndpoint = '/users/ledge-api/';
const kGetUsersEndpoint = '/users/ledge-api/';

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
    try {
      final res = await _httpClient.post(
        // Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
        /// Uri parse and Uri https both will work but in case we need to pass any params with methods like get
        /// or some other methods we can pass them using https whereas we cant using parse
        Uri.https(kBaseUrl!, kCreateUserEndpoint),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw ServerException(message: res.body, statusCode: res.statusCode);
      }
    } on ServerException {
      /// here this on ServerException is to make sure if server throws an Exception we just rethrow it
      rethrow;
    } catch (e) {
      /// and in cases when server doesn't throw an Exception and it could be a dart error we will throw an Exception with custom 505 StatusCode
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // final res = await _httpClient.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint'));
      final res = await _httpClient.get(
        Uri.https(kBaseUrl!, kGetUsersEndpoint),
      );
      if (res.statusCode != 200) {
        throw ServerException(message: res.body, statusCode: res.statusCode);
      }

      /// here we are returning because a List is expected now how this return block works : this takes data from server
      /// (res.body) decode it (jsonDecode) as a List (as List) create cast as DataMap (List<DataMap>) {here we can also
      /// use .cast<> but writing in the way we wrote is cleaner}. Then we traverse through each map (.map((UserData))
      /// and then  we will create a list for it (.tiList()) and return that list (return)
      return List<DataMap>.from(
        jsonDecode(res.body) as List,
      ).map((userData) => UserModel.fromMap(userData)).toList();
    } on ServerException {
      /// now just like createUser
      /// here this on ServerException is to make sure if server throws an Exception we just rethrow it
      rethrow;
    } catch (e) {
      /// and in cases when server doesn't throw an Exception and it could be a dart error we will throw an Exception with custom 505 StatusCode
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }
}
