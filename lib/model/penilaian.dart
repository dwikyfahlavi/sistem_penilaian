class Penilaian {
  String? materiKU;
  double? nilaiPretest;
  double? nilaiPosttest;
  String? nilaiHuruf;
  double? nilaiAngka;
  double? bobot;
  String? peserta;
  String? error;

  Penilaian(
      {this.materiKU,
      this.nilaiPretest,
      this.nilaiPosttest,
      this.nilaiHuruf,
      this.nilaiAngka,
      this.bobot,
      this.peserta,
      this.error});

  Penilaian.fromJson(Map<String, dynamic> json) {
    materiKU = json['materiKU'];
    nilaiPretest = json['nilaiPretest'];
    nilaiPosttest = json['nilaiPosttest'];
    nilaiHuruf = json['nilaiHuruf'];
    nilaiAngka = json['nilaiAngka'];
    bobot = json['bobot'];
    peserta = json['peserta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['materiKU'] = materiKU;
    data['nilaiPretest'] = nilaiPretest;
    data['nilaiPosttest'] = nilaiPosttest;
    data['nilaiHuruf'] = nilaiHuruf;
    data['nilaiAngka'] = nilaiAngka;
    data['bobot'] = bobot;
    data['peserta'] = peserta;
    return data;
  }

  Penilaian.withError(String errorValue)
      : materiKU = null,
        nilaiPretest = null,
        nilaiPosttest = null,
        nilaiHuruf = null,
        nilaiAngka = null,
        bobot = null,
        peserta = null,
        error = errorValue;
}

class IpkModel {
  int? id;
  double? ipKelulusan;
  String? namaMahasiswa;
  String? error;

  IpkModel({this.id, this.ipKelulusan, this.namaMahasiswa});

  IpkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ipKelulusan = json['ipKelulusan'];
    namaMahasiswa = json['namaMahasiswa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ipKelulusan'] = ipKelulusan;
    data['namaMahasiswa'] = namaMahasiswa;
    return data;
  }

  IpkModel.withError(String errorValue)
      : id = null,
        ipKelulusan = null,
        namaMahasiswa = null,
        error = errorValue;
}
