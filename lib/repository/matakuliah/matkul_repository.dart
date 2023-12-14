import 'package:sistem_penilaian/model/mataKuliah.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/repository/matakuliah/matkul_api_provider.dart';

class MatkulRepository {
  final MatkulApiProvider _apiProvider = MatkulApiProvider();

  Future<List<MataKuliah>> getMatkul(String token) {
    return _apiProvider.getMatkul(token);
  }

  Future<MataKuliah?> updateMatkul(
      String name, int id, String token, bool isDelete) {
    return _apiProvider.updateMatkul(name, id, token, isDelete);
  }

  Future<List<Penilaian>> getNilai(int id, String token) {
    return _apiProvider.getNilai(id, token);
  }

  Future<List<IpkModel>> getIpkUser(String token) {
    return _apiProvider.getIpkUser(token);
  }

  Future<MataKuliah> addMatkul(MataKuliah mataKuliah, String token) {
    return _apiProvider.addMatkul(mataKuliah, token);
  }

  Future<User?> loginUser(String email, String password) {
    return _apiProvider.loginUser(email, password);
  }

  Future<User?> getProfile(String token) {
    return _apiProvider.getProfile(token);
  }

  Future<String?> updatePassword(
      String email, String oldPass, String newPass, String token) {
    return _apiProvider.updatePassword(email, oldPass, newPass, token);
  }
}
