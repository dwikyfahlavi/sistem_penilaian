import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sistem_penilaian/model/mataKuliah.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/repository/matakuliah/matkul_repository.dart';

class MataKuliahBloc {
  final MatkulRepository _repository = MatkulRepository();

  final TextEditingController mataKuliah = TextEditingController();
  final TextEditingController jumlahSKS = TextEditingController();
  final TextEditingController nim = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  User? user;
  String? role;
  List<Penilaian>? listNilai = [];
  List<IpkModel> listIpk = [];
  List<MataKuliah> listMatkul = [];

  final BehaviorSubject<String?> _role = BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<User?> _subject = BehaviorSubject<User?>.seeded(null);
  final BehaviorSubject<List<MataKuliah>> _matkul =
      BehaviorSubject<List<MataKuliah>>.seeded([]);
  final BehaviorSubject<String?> _userAdd =
      BehaviorSubject<String?>.seeded(null);

  ValueStream<String?> get roleStream => _role.stream;

  BehaviorSubject<User?> get subject => _subject;
  BehaviorSubject<List<MataKuliah>> get matkul => _matkul;
  BehaviorSubject<String?> get userAdd => _userAdd;

  getMatkul(String token) async {
    List<MataKuliah> response = await _repository.getMatkul(token);
    listMatkul = response;
    _matkul.sink.add(listMatkul);
  }

  Future<MataKuliah?> updateMatkul(
      String name, int id, String token, bool isDelete) async {
    MataKuliah? response =
        await _repository.updateMatkul(name, id, token, isDelete);
    if (response!.error == null) {
      if (isDelete) {
        await getMatkul(token);
      } else {
        for (var data in listMatkul) {
          if (data.id == id) {
            data.nama = name;
          }
        }
        matkul.sink.add(listMatkul);
      }
    }
    return response;
  }

  Future<MataKuliah> addMatkul(String token) async {
    MataKuliah matkul =
        MataKuliah(nama: name.text, jumlahSKS: int.parse(jumlahSKS.text));
    MataKuliah response = await _repository.addMatkul(matkul, token);
    await getMatkul(token);
    return response;
  }

  getNilai(String token) async {
    List<Penilaian> response = await _repository.getNilai(token);
    listNilai = response;
  }

  getIpkUser(String token) async {
    listIpk = await _repository.getIpkUser(token);
    _matkul.sink.add(listMatkul);
  }

  getProfile(String token) async {
    user = await _repository.getProfile(token);
    name.text = user?.name ?? '';
    _subject.sink.add(user);
  }

  Future<String?> updatePassword(String token) async {
    String? response = await _repository.updatePassword(
        user!.email!, password.text, newPassword.text, token);
    return response;
  }

  Future<User?> loginUser(String email, String password) async {
    user = await _repository.loginUser(email, password);
    _subject.sink.add(user);
    return user;
  }

  setRole(String value) {
    role = value;
    _role.sink.add(value);
  }

  dispose() {
    _subject.close();
    _userAdd.close();
    _role.close();
  }
}
