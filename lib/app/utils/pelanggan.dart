class Pelanggan {
  final String nama;
  final String id;
  final String phone;
  final String kategori;

  Pelanggan({
    required this.nama,
    required this.id,
    required this.phone,
    required this.kategori,
  });

  factory Pelanggan.fromMap(Map<String, dynamic> map) {
    return Pelanggan(
      nama: map['nama'] as String,
      id: map['id_user'] as String,
      phone: map['no_telp'] as String, // Map the phone number
      kategori: map['kategori'] as String,
    );
  }
}
