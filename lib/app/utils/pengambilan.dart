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
    required this.id,
    required this.nama,
    required this.phone,
    required this.berat,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.statusCucian,
  });

  factory Pengambilan.fromMap(Map<String, dynamic> map) {
    return Pengambilan(
      id: map['transaksi_id'],
      nama: map['nama_pelanggan'] as String,
      phone: map['nomor_pelanggan'] as String,
      berat: map['berat_laundry'] as String,
      totalHarga: map['total_biaya'] as String,
      metodePembayaran: map['metode_pembayaran'] as String,
      statusPembayaran: map['status_pembayaran'] as String,
      statusCucian: map['status_cucian'] as String,
    );
  }
}
