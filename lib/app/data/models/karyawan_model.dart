class Karyawan {
  int? karyawanId;
  String? noHp;
  String? namaKaryawan;
  int? uid;
  String? createdAt;

  Karyawan(
      {this.karyawanId,
      this.noHp,
      this.namaKaryawan,
      this.uid,
      this.createdAt});

  Karyawan.fromJson(Map<String, dynamic> json) {
    karyawanId = json['karyawan_id'];
    noHp = json['no_hp'];
    namaKaryawan = json['nama_karyawan'];
    uid = json['uid'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['karyawan_id'] = karyawanId;
    data['no_hp'] = noHp;
    data['nama_karyawan'] = namaKaryawan;
    data['uid'] = uid;
    data['created_at'] = createdAt;
    return data;
  }

  static List<Karyawan> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Karyawan.fromJson(e)).toList();
  }
}
