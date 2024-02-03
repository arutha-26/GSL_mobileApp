import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_data_transaksi_controller.dart';

class DetailDataTransaksiView extends GetView<DetailDataTransaksiController> {
  DetailDataTransaksiView({super.key});

  final TextEditingController _harga = TextEditingController();

  String formatCurrency(num value) {
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return currencyFormatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data dari halaman sebelumnya
    final Map<String, dynamic> dataPanel = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Transaksi'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getDataTransaksi(dataPanel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          if (snapshot.data is! Map<String, dynamic>) {
            return const Center(child: Text('Invalid data format'));
          }

          final Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

          _harga.text = data['harga_kilo']?.toString() ?? '';

          return Column(children: [
            Container(
              height: 700,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scrollbar(
                thickness: 3,
                radius: const Radius.circular(20),
                scrollbarOrientation: ScrollbarOrientation.right,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: ListView(
                  padding: const EdgeInsets.all(5),
                  children: [
                    Image.asset(
                      'images/history_icon.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 5),

                    // TextRow(
                    //     label: 'Transaksi ID', value: data['id_transaksi']?.toString() ?? '-'),
                    // const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Karyawan Penerima',
                        value: data['id_karyawan_masuk']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Pelanggan',
                        value: data['id_user']['nama']?.toString().capitalizeFirst ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nomor Pelanggan',
                        value: data['id_user']['no_telp']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Kategori Pelanggan',
                        value: data['id_user']['kategori']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Alamat Pelanggan',
                        value: data['id_user']['alamat']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Berat Laundry', value: '${data['berat_laundry']} Kg' ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Layanan Laundry',
                        value: data['layanan_laundry']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Metode Laundry',
                        value: data['metode_laundry']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Datang', value: formatDate(data['tanggal_datang'])),
                    const SizedBox(height: 5),

                    TextRow(
                      label: 'Total Biaya',
                      value: formatCurrency(data['total_biaya'] ?? 0),
                    ),

                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Metode Pembayaran',
                        value: data['metode_pembayaran']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Status Pembayaran',
                        value: getStatusPembayaran(data['status_pembayaran'])),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Status Cucian',
                        value: data['status_cucian']?.toString().capitalizeFirst ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Selesai', value: formatDate(data['tanggal_selesai'])),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Karyawan Keluar',
                        value: data['id_karyawan_keluar']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Diambil', value: formatDate(data['tanggal_diambil'])),
                    const SizedBox(height: 5),

                    Visibility(
                      visible: data['bukti_transfer'] != null,
                      child: ImageRow(
                          label: 'Bukti Transfer', value: data['bukti_transfer'] ?? '-'),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Await the result of getDataTransaksi
                Map<String, dynamic> data = await controller.getDataTransaksi(dataPanel);

                // Check if data is not blank
                if (data.isNotEmpty) {
                  // Now that you have the data, call generateAndOpenInvoicePDF
                  await controller.generateAndOpenInvoicePDF(data);
                } else {
                  Get.snackbar(
                    'Error',
                    'Data Tidak Ditemukan, Gagal Mencetak Invoice!',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.greenAccent,
                minimumSize: const Size(350, 45),
              ),
              child: const Text('Cetak Invoice'),
            )
          ]);
        },
      ),
    );
  }

  String getStatusPembayaran(String? status) {
    if (status == 'belum_dibayar') {
      return 'Belum Lunas';
    } else if (status == 'sudah_dibayar') {
      return 'Lunas';
    }
    return status ?? '-';
  }

  String formatDate(String? dateString) {
    if (dateString == null) return '-';
    final DateTime date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  const TextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}

class ImageRow extends StatelessWidget {
  final String label;
  final String value;

  const ImageRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Image.network(
          value,
          width: 300,
        ),
      ],
    );
  }
}
