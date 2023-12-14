import 'package:dio/dio.dart';
import 'package:sistem_penilaian/model/mataKuliah.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';

class MatkulApiProvider {
  final String _endpoint = "http://10.0.2.2:8080/";
  late Dio _dio;

  MatkulApiProvider() {
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

  Future<List<MataKuliah>> getMatkul(String bearerToken) async {
    try {
      Response<List<dynamic>> response =
          await _dio.get('materiKU', options: getOption(bearerToken));
      return response.data!.map((data) => MataKuliah.fromJson(data)).toList();
    } catch (error) {
      return [MataKuliah.withError(_handleError(error as DioException))];
    }
  }

  Future<List<Penilaian>> getNilai(int id, String bearerToken) async {
    try {
      Response<List<dynamic>> response =
          await _dio.get('nilai/peserta/$id', options: getOption(bearerToken));
      return response.data!.map((data) => Penilaian.fromJson(data)).toList();
    } catch (error) {
      return [Penilaian.withError(_handleError(error as DioException))];
    }
  }

  Future<List<IpkModel>> getIpkUser(String bearerToken) async {
    try {
      Response<List<dynamic>> response = await _dio.get('ipKelulusan/peserta',
          options: getOption(bearerToken));
      return response.data!.map((data) => IpkModel.fromJson(data)).toList();
    } catch (error) {
      return [IpkModel.withError(_handleError(error as DioException))];
    }
  }

  Future<MataKuliah> addMatkul(MataKuliah matkul, String token) async {
    try {
      Response response = await _dio.post('materiKU',
          options: getOption(token),
          data: {"name": matkul.nama, "jumlahSks": matkul.jumlahSKS});
      return MataKuliah.fromJson(response.data);
    } catch (error) {
      return MataKuliah.withError(_handleError(error as DioException));
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

  Future<MataKuliah> updateMatkul(
      String name, int id, String bearerToken, bool isDelete) async {
    try {
      if (!isDelete) {
        Response response = await _dio.patch('materiKU/$id',
            data: {"name": name},
            options: Options(headers: {
              'Authorization': 'Bearer $bearerToken',
            }));
      } else {
        Response response = await _dio.delete('materiKU/$id',
            options: Options(headers: {
              'Authorization': 'Bearer $bearerToken',
            }));
      }
      // Map<String, dynamic> jsonMap = json.decode(response.data);
      return MataKuliah();
    } catch (error) {
      return MataKuliah.withError(_handleError(error as DioException));
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
