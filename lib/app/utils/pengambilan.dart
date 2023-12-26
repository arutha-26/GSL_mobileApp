class Pengambilan {
  final String nama;
  final String id;
  final String phone;
  final String berat;
  final String totalHarga;
  final String metodePembayaran;
  final String statusPembayaran;
  final String statusCucian;

  Pengambilan({
    required this.nama,
    required this.id,
    required this.phone,
    required this.berat,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.statusCucian,
  });

  factory Pengambilan.fromMap(Map<String, dynamic> map) {
    return Pengambilan(
      nama: map['nama_pelanggan'] as String,
      id: map['id_transaksi'] as String,
      phone: map['nomor_pelanggan'] as String,
      // Map the phone number
      berat: map['berat_laundry'] as String,
      totalHarga: map['total_biaya'] as String,
      metodePembayaran: map['metode_pembayaran'] as String,
      statusPembayaran: map['status_pembayaran'] as String,
      statusCucian: map['status_cucian'] as String,
    );
  }
}
