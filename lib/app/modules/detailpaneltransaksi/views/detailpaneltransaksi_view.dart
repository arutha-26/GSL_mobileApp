import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detailpaneltransaksi_controller.dart';

class DetailpaneltransaksiView extends GetView<DetailpaneltransaksiController> {
  DetailpaneltransaksiView({super.key});
  final TextEditingController _harga = TextEditingController();

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

          return Container(
            height: 700,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView(
              padding: const EdgeInsets.all(5),
              children: [
                Image.asset(
                  'images/history_icon.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 5),

                TextRow(label: 'Transaksi ID', value: data['transaksi_id']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Nama Karyawan Penerima',
                    value: data['nama_karyawan_masuk']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Nama Pelanggan', value: data['nama_pelanggan']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Nomor Pelanggan',
                    value: data['nomor_pelanggan']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Kategori Pelanggan',
                    value: data['kategori_pelanggan']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(label: 'Berat Laundry', value: '${data['berat_laundry']} Kg' ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Layanan Laundry',
                    value: data['layanan_laundry']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Metode Laundry', value: data['metode_laundry']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(label: 'Tanggal Datang', value: formatDate(data['tanggal_datang'])),
                const SizedBox(height: 5),

                TextRow(label: 'Total Biaya', value: 'Rp ${data['total_biaya']},000' ?? '-'),
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

                TextRow(label: 'Tanggal Selesai', value: formatDate(data['tanggal_selesai'])),
                const SizedBox(height: 5),

                TextRow(
                    label: 'Nama Karyawan Keluar',
                    value: data['nama_karyawan_keluar']?.toString() ?? '-'),
                const SizedBox(height: 5),

                TextRow(label: 'Tanggal Diambil', value: formatDate(data['tanggal_diambil'])),
                const SizedBox(height: 5),
                // Text fields for editing prices
              ],
            ),
          );
        },
      ),
    );
  }

  String getStatusPembayaran(String? status) {
    if (status == 'belum_dibayar') {
      return 'Belum Dibayar';
    } else if (status == 'sudah_dibayar') {
      return 'Sudah Dibayar';
    }
    return status ?? '-';
  }

  String formatDate(String? dateString) {
    if (dateString == null) return '-';
    final DateTime date = DateTime.parse(dateString);
    return '${date.day}-${date.month}-${date.year}';
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  const TextRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
