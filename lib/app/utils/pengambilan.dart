class Pengambilan {
  final String nama;
  final String id;
  final String phone;
  final String kategori;

  Pengambilan({
    required this.nama,
    required this.id,
    required this.phone,
    required this.kategori,
  });

  factory Pengambilan.fromMap(Map<String, dynamic> map) {
    return Pengambilan(
      nama: map['nama'] as String,
      id: map['id'] as String,
      phone: map['phone'] as String, // Map the phone number
      kategori: map['kategori'] as String,
    );
  }
}
