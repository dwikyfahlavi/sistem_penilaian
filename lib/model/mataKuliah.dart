class MataKuliah {
  int? id;
  String? nama;
  int? jumlahSKS;
  String? error;

  MataKuliah({this.id, this.nama, this.jumlahSKS});

  MataKuliah.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    jumlahSKS = json['jumlahSKS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    return data;
  }

  MataKuliah.withError(String errorValue)
      : id = null,
        nama = null,
        error = errorValue;
}
