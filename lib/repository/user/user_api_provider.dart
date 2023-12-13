import 'package:dio/dio.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';

class UserApiProvider {
  final String _endpoint = "http://10.0.2.2:8080/";
  late Dio _dio;

  UserApiProvider() {
    BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(seconds: 5000),
        connectTimeout: const Duration(seconds: 5000),
        baseUrl: _endpoint);
    _dio = Dio(options);
  }

  getOption(String bearerToken) {
    Options options = Options(headers: {
      'Authorization': 'Bearer $bearerToken',
    });
    return options;
  }

  Future<UserModel> getUser(String token) async {
    try {
      Response response = await _dio.get('user', options: getOption(token));
      return UserModel.fromJson(response.data);
    } catch (error) {
      return UserModel.withError(_handleError(error as DioException));
    }
  }

  Future<UserModel> deleteUser(int id, String bearerToken) async {
    try {
      Response response = await _dio.delete('user/$id',
          options: Options(headers: {
            'Authorization': 'Bearer $bearerToken',
          }));

      // Map<String, dynamic> jsonMap = json.decode(response.data);
      return UserModel();
    } catch (error) {
      return UserModel.withError(_handleError(error as DioException));
    }
  }

  Future<String> addUser(User user) async {
    try {
      Response response = await _dio.post('register', data: {
        "nim": user.nim,
        "email": user.email,
        "name": user.name,
        "password": user.password,
        "role": [user.role!.first]
      });
      return response.data['message'];
    } catch (error) {
      return _handleError(error as DioException);
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      Response response = await _dio
          .post('login', data: {"email": email, "password": password});
      return User.fromJson(response.data);
    } catch (error) {
      // return User();
      if (error.toString().isNotEmpty) {
        return User.withError(_handleError(error as DioException));
      }
      return null;
    }
  }

  //profile

  Future<User> getProfile(String bearerToken) async {
    try {
      Response response = await _dio.get('profile',
          options: Options(headers: {
            'Authorization': 'Bearer $bearerToken',
          }));
      return User.fromJson(response.data);
    } catch (error) {
      return User.withError(_handleError(error as DioException));
    }
  }

  Future<String> updateProfile(String name, String bearerToken) async {
    try {
      Response response = await _dio.patch('profile',
          data: {"name": name},
          options: Options(headers: {
            'Authorization': 'Bearer $bearerToken',
          }));
      return response.data['message'];
    } catch (error) {
      return _handleError(error as DioException);
    }
  }

  Future<String> updatePassword(
      String email, String oldPass, String newPass, String bearerToken) async {
    try {
      Response response = await _dio.patch('updatePassword',
          data: {
            "email": email,
            "oldPassword": oldPass,
            "newPassword": newPass
          },
          options: Options(headers: {
            'Authorization': 'Bearer $bearerToken',
          }));
      return response.data['message'];
    } catch (error) {
      return _handleError(error as DioException);
    }
  }

  Future<List<Penilaian>> getAllNilai(int id, String bearerToken) async {
    try {
      Response<List<dynamic>> response =
          await _dio.get('nilai/peserta/$id', options: getOption(bearerToken));
      return response.data!.map((data) => Penilaian.fromJson(data)).toList();
    } catch (error) {
      return [Penilaian.withError(_handleError(error as DioException))];
    }
  }

  Future<List<IpkModel>> getIpkById(int id, String bearerToken) async {
    try {
      Response<List<dynamic>> response = await _dio
          .get('ipKelulusan/peserta/$id', options: getOption(bearerToken));
      return response.data!.map((data) => IpkModel.fromJson(data)).toList();
    } catch (error) {
      return [IpkModel.withError(_handleError(error as DioException))];
    }
  }

  Future<Penilaian> addNilai(Penilaian nilai, int id, String token) async {
    try {
      Response response =
          await _dio.post('nilai', options: getOption(token), data: {
        "nilaiPretest": nilai.nilaiPretest,
        "nilaiPosttest": nilai.nilaiPosttest,
        "materiKU": nilai.materiKU,
        "idMahasiswa": id
      });
      return Penilaian.fromJson(response.data);
    } catch (error) {
      return Penilaian.withError(_handleError(error as DioException));
    }
  }

  Future<String> generateIPKUser(String bearerToken) async {
    try {
      Response response = await _dio.post('ipKelulusan',
          options: Options(headers: {
            'Authorization': 'Bearer $bearerToken',
          }));
      return response.data['message'];
    } catch (error) {
      return _handleError(error as DioException);
    }
  }

  String _handleError(DioException error) {
    String errorDescription = "";
    DioException dioError = error;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioExceptionType.unknown:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        errorDescription = "${dioError.response?.data['message']}";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
      default:
        errorDescription = "Unexpected error occured";
        break;
    }

    return errorDescription;
  }
}
