class InvoiceData {
  final String namaPelanggan;
  final String nomorPelanggan;
  final String alamatPelanggan;
  final int idTransaksi;
  final String tanggalDatang;
  final String metodeLaundry;
  final String layananLaundry;
  final int beratLaundry;
  final int totalBiaya;
  final String statusCucian;
  final String statusPembayaran;

  InvoiceData({
    required this.namaPelanggan,
    required this.nomorPelanggan,
    required this.alamatPelanggan,
    required this.idTransaksi,
    required this.tanggalDatang,
    required this.metodeLaundry,
    required this.layananLaundry,
    required this.beratLaundry,
    required this.totalBiaya,
    required this.statusCucian,
    required this.statusPembayaran,
  });

  factory InvoiceData.fromMap(Map<String, dynamic> map) {
    return InvoiceData(
      namaPelanggan: map['nama_pelanggan'] as String? ?? '',
      nomorPelanggan: map['nomor_pelanggan'] as String? ?? '',
      alamatPelanggan: map['alamat'] as String? ?? '',
      idTransaksi: map['transaksi_id'] as int? ?? 0,
      tanggalDatang: map['tanggal_datang'] as String? ?? '',
      metodeLaundry: map['metode_laundry'] as String? ?? '',
      layananLaundry: map['layanan_laundry'] as String? ?? '',
      beratLaundry: map['berat_laundry'] as int? ?? 0,
      totalBiaya: map['total_biaya'] as int? ?? 0,
      statusCucian: map['status_cucian'] as String? ?? '',
      statusPembayaran: map['status_pembayaran'] as String? ?? '',
    );
  }
}
