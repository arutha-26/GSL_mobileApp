class Pelanggan {
  final String nama;
  final String id;
  final String phone; // Add phone number field

  Pelanggan({
    required this.nama,
    required this.id,
    required this.phone, // Include phone number in the constructor
  });

  factory Pelanggan.fromMap(Map<String, dynamic> map) {
    return Pelanggan(
      nama: map['nama'] as String,
      id: map['id'] as String,
      phone: map['phone'] as String, // Map the phone number
    );
  }
}
