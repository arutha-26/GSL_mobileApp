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
  final String tglDatang;

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
    required this.tglDatang,
  });

  factory Pengambilan.fromMap(Map<String, dynamic> map) {
    return Pengambilan(
      idTransaksi: map['id_transaksi'],
      idUser: map['id_user.id_user'],
      nama: map['nama'],
      noTelp: map['no_telp'],
      berat: map['berat_laundry'] as String,
      totalHarga: map['total_biaya'] as String,
      metodePembayaran: map['metode_pembayaran'] as String,
      statusPembayaran: map['status_pembayaran'] as String,
      statusCucian: map['status_cucian'] as String,
      tglDatang: map['tanggal_datang'] as String,
    );
  }
}
