class Pengambilan {
  final String idTransaksi;
  final String idUser;
  final String nama;
  final String noTelp;
  final String berat;
  final String totalHarga;
  final String metodePembayaran;
  final String statusPembayaran;
  final String statusCucian;

  Pengambilan({
    required this.idTransaksi,
    required this.idUser,
    required this.nama,
    required this.noTelp,
    required this.berat,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.statusCucian,
  });

  factory Pengambilan.fromMap(Map<String, dynamic> map) {
    return Pengambilan(
      idTransaksi: map['transaksi.id_transaksi'],
      idUser: map['user.id_user'],
      nama: map['user.nama'],
      noTelp: map['user.no_telp'],
      berat: map['transaksi.berat_laundry'] as String,
      totalHarga: map['transaksi.total_biaya'] as String,
      metodePembayaran: map['transaksi.metode_pembayaran'] as String,
      statusPembayaran: map['transaksi.status_pembayaran'] as String,
      statusCucian: map['transaksi.status_cucian'] as String,
    );
  }
}
