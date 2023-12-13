import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/repository/user/user_api_provider.dart';

class UserRepository {
  final UserApiProvider _apiProvider = UserApiProvider();

  Future<UserModel> getUser(String token) {
    return _apiProvider.getUser(token);
  }

  Future<UserModel> deleteUser(int id, String token) {
    return _apiProvider.deleteUser(id, token);
  }

  Future<String> addUser(User user) {
    return _apiProvider.addUser(user);
  }

  Future<String> generateIPKUser(String token) {
    return _apiProvider.generateIPKUser(token);
  }

  Future<User?> loginUser(String email, String password) {
    return _apiProvider.loginUser(email, password);
  }

  Future<User?> getProfile(String token) {
    return _apiProvider.getProfile(token);
  }

  Future<List<Penilaian>?> getAllNilai(int id, String token) {
    return _apiProvider.getAllNilai(id, token);
  }

  Future<Penilaian> addNilai(Penilaian nilai, int id, String token) {
    return _apiProvider.addNilai(nilai, id, token);
  }

  Future<List<IpkModel>> getIpkById(int id, String token) {
    return _apiProvider.getIpkById(id, token);
  }

  Future<String?> updateProfile(String name, String token) {
    return _apiProvider.updateProfile(name, token);
  }

  Future<String?> updatePassword(
      String email, String oldPass, String newPass, String token) {
    return _apiProvider.updatePassword(email, oldPass, newPass, token);
  }
}
