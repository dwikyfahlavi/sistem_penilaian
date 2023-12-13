import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/repository/user/user_repository.dart';

class UserBloc {
  final UserRepository _repository = UserRepository();

  final TextEditingController nim = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController nilaiPretest = TextEditingController();
  final TextEditingController nilaiPosttest = TextEditingController();
  User? user;
  String? role;
  List<IpkModel>? ipkModel;
  List<Penilaian>? listNilai = [];

  final BehaviorSubject<String?> _role = BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<User?> _subject = BehaviorSubject<User?>.seeded(null);
  final BehaviorSubject<List<User>?> _subjectListUser =
      BehaviorSubject<List<User>?>.seeded([]);
  final BehaviorSubject<String?> _userAdd =
      BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<List<Penilaian>?> _listPenilaian =
      BehaviorSubject<List<Penilaian>?>.seeded([]);

  ValueStream<String?> get roleStream => _role.stream;

  BehaviorSubject<User?> get subject => _subject;
  BehaviorSubject<List<Penilaian>?> get listPenilaian => _listPenilaian;
  BehaviorSubject<List<User>?> get subjectListUser => _subjectListUser;
  BehaviorSubject<String?> get userAdd => _userAdd;

  getUser(String token) async {
    UserModel response = await _repository.getUser(token);
    _subjectListUser.sink.add(response.eEmbedded!.user);
  }

  generateIPKUser(String token) async {
    String response = await _repository.generateIPKUser(token);
    return response;
  }

  getProfile(String token) async {
    user = await _repository.getProfile(token);
    name.text = user?.name ?? '';
    _subject.sink.add(user);
  }

  Future<Penilaian> addNilai(int id, String token) async {
    Penilaian nilai = Penilaian(
      materiKU: name.text,
      nilaiPretest: double.parse(nilaiPretest.text),
      nilaiPosttest: double.parse(nilaiPosttest.text),
    );
    Penilaian response = await _repository.addNilai(nilai, id, token);
    await getAllNilai(id, token);
    return response;
  }

  Future<List<Penilaian>?> getAllNilai(int id, String token) async {
    List<Penilaian>? response = await _repository.getAllNilai(id, token);
    listNilai = response;
    listPenilaian.sink.add(listNilai);
    return listNilai;
  }

  Future<List<IpkModel>?> getIpkById(int id, String token) async {
    ipkModel = await _repository.getIpkById(id, token);
    return ipkModel;
  }

  Future<UserModel?> deleteUser(int id, String token) async {
    UserModel? response = await _repository.deleteUser(id, token);
    if (response.error == null) {
      await getUser(token);
    }
    return response;
  }

  Future<String?> updateProfile(String name, String token) async {
    String? response = await _repository.updateProfile(name, token);
    user!.name = name;
    _subject.sink.add(user);
    return response;
  }

  Future<String?> updatePassword(String token) async {
    String? response = await _repository.updatePassword(
        user!.email!, password.text, newPassword.text, token);
    return response;
  }

  Future<String> addUser() async {
    User user = User(
        nim: nim.text,
        email: email.text,
        name: name.text,
        password: password.text,
        role: [role!]);
    String response = await _repository.addUser(user);
    _userAdd.sink.add(response);
    return response;
  }

  Future<User?> loginUser(String email, String password) async {
    user = await _repository.loginUser(email, password);
    _subject.sink.add(user);
    return user;
  }

  setRole(String value) {
    role = value;
    _role.sink.add(role);
  }

  dispose() {
    _subject.close();
    _userAdd.close();
    _role.close();
  }
}
