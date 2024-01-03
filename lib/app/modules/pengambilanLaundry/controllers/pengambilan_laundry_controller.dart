import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/pengambilan.dart';

class PengambilanLaundryController extends GetxController {
  void clearInputs() {
    namaKaryawanC.clear();
    idTransaksiController.clear();
    tanggalDiambilController.clear();
    beratLaundryController.clear();
    hargaTotalController.clear();
    nameController.clear();
    phoneController.clear();
    beratController.clear();
    totalHargaController.clear();
    selectedPembayaran.value = "-";
    statusCucian.value = 'diproses';
    statusPembayaran.value = 'belum_dibayar';
  }

  @override
  void onClose() {
    // Clear input fields
    clearInputs();
    namaKaryawanC.dispose();
    idTransaksiController.dispose();
    nameController.dispose();
    phoneController.dispose();
    tanggalDiambilController.dispose();
    beratLaundryController.dispose();
    hargaTotalController.dispose();
    nameController.dispose();
    beratLaundryController.removeListener(() {});
    super.onClose();
  }

  RxString statusCucian = 'diproses'.obs;
  RxString statusPembayaran = 'belum_dibayar'.obs;
  RxBool isLoading = false.obs;
  TextEditingController namaKaryawanC = TextEditingController();
  TextEditingController tanggalDiambilController = TextEditingController();
  TextEditingController beratLaundryController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController idTransaksiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController totalHargaController = TextEditingController();
  TextEditingController metodePembayaranController = TextEditingController();
  TextEditingController statusPembayaranController = TextEditingController();
  TextEditingController statusCucianController = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengonversi nilai status_pembayaran
  String convertStatusPembayaran(String status) {
    if (status == 'belum_dibayar') {
      return 'Belum Dibayar';
    } else if (status == 'sudah_dibayar') {
      return 'Sudah Dibayar';
    } else {
      return 'Unknown'; // Tambahkan nilai default jika diperlukan
    }
  }

  String formatTotalHarga(String totalHarga) {
    // Menghapus tanda dollar ('$') dari string totalHarga
    totalHarga = totalHarga.replaceAll('\$', '');

    // Mengonversi totalHarga menjadi bilangan bulat
    double hargaAngka = double.parse(totalHarga);

    // Mengonversi hargaAngka ke format mata uang Rupiah
    String hargaRupiah = 'Rp${NumberFormat('#,###').format(hargaAngka)}';

    return hargaRupiah;
  }

  Future<List<Pengambilan>> fetchDataTransaksi(String query) async {
    List<Pengambilan> results = [];

    try {
      final response = await client
          .from('transaksi')
          .select(
              'nama_pelanggan, transaksi_id, nomor_pelanggan, berat_laundry, total_biaya, metode_pembayaran, status_pembayaran, status_cucian')
          .in_('status_cucian', ['diproses', 'selesai'])
          .ilike('nama_pelanggan, nomor_pelanggan', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          final nama = item['nama_pelanggan']?.toString() ?? '';
          final id = item['transaksi_id']?.toString() ?? '';
          final phone = item['nomor_pelanggan']?.toString() ?? '';
          final berat = item['berat_laundry']?.toString() ?? '';
          final totalHarga = item['total_biaya']?.toString() ?? '';
          final metodePembayaran = item['metode_pembayaran']?.toString() ?? '';
          final statusPembayaran = item['status_pembayaran']?.toString() ?? '';
          final statusCucian = item['status_cucian']?.toString() ?? '';

          // Menggunakan fungsi formatTotalHarga untuk mengonversi totalHarga
          final formattedTotalHarga = formatTotalHarga(totalHarga);

          return Pengambilan(
            nama: nama,
            id: id,
            phone: phone,
            berat: '$berat Kg',
            totalHarga: formattedTotalHarga,
            metodePembayaran: metodePembayaran,
            statusPembayaran: convertStatusPembayaran(statusPembayaran),
            statusCucian: statusCucian.toString().capitalizeFirst as String,
          );
        }).toList();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
    }
    return results;
  }

  Future<void> getDataKaryawan() async {
    List<dynamic> res =
        await client.from("user").select().match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    namaKaryawanC.text = user["nama"];
  }

  Future<void> updateTransaksi() async {
    if (namaKaryawanC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        var dataTransaksi = {};

        if (statusCucian.value == 'diambil') {
          dataTransaksi["nama_karyawan_keluar"] = namaKaryawanC.text;
          dataTransaksi["tanggal_diambil"] = formatDate(tanggalDiambilController.text);
          dataTransaksi["metode_pembayaran"] = getSelectedPembayaran();
          dataTransaksi["status_pembayaran"] = statusPembayaran.value;
          // Jika status_cucian == diambil, update semua data
          dataTransaksi["status_cucian"] = statusCucian.value;
          dataTransaksi["is_hidden"] = true;
          dataTransaksi["edit_at"] = DateTime.now().toString();
        } else {
          // Jika status_cucian != diambil, hanya update status_cucian
          dataTransaksi["status_cucian"] = statusCucian.value;
          dataTransaksi["edit_at"] = DateTime.now().toString();
        }

        // Log the dataTransaksi to the console
        if (kDebugMode) {
          print("Data to be inserted into transaksi: $dataTransaksi");
        }

        await client
            .from("transaksi")
            .update(dataTransaksi)
            .match({"transaksi_id": idTransaksiController.text}).execute();

        // Kirim pesan WhatsApp setelah transaksi berhasil disimpan
        String nomorPelanggan = phoneController.text;
        String pesan = '';

        await kirimPesanWhatsApp(nomorPelanggan, pesan);

        clearInputs();

        Get.defaultDialog(
          barrierDismissible: false,
          title: "Pembaharuan Data Transaksi Berhasil",
          middleText: "Data berhasil diperbaharui.",
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        );
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Seluruh data harus terisi!");
    }
    isLoading.value = false;
    refresh();
  }

  Future<void> kirimPesanWhatsApp(String nomorPelanggan, String pesan) async {
    String whatsappNumber = nomorPelanggan; // Replace with the actual WhatsApp number

    String generateRandomNotaNumber() {
      // Generate a random 12-digit number
      Random random = Random();
      int randomNumber = random.nextInt(10000);

      // Format the random number as a string with leading zeros if necessary
      String formattedNumber = randomNumber.toString().padLeft(8, '0');

      return formattedNumber;
    }

    String convertStatusPembayaranToString(String statusPembayaran) =>
        statusPembayaran == 'belum_dibayar' ? 'Belum Dibayar' : 'Sudah Dibayar';

    String message = '''
FAKTUR ELEKTRONIK

GREEN SPIRIT LAUNDRY
Jl. UNGASAN
089788786564

Pelanggan Yth,
${nameController.text}

Kami informasikan untuk nomor nota ${idTransaksiController.text.toString()} telah selesai kami kerjakan.

Silakan datang untuk melakukan pengambilan DAN TUNJUKKAN NOTA TRANSAKSI SEBAGAI BUKTI KEPEMILIKAN

Berikut detail penagihannya:
Total Biaya: ${totalHargaController.text.toString()}
Status: ${convertStatusPembayaranToString(statusPembayaran.value)}

JAM OPERATIONAL LAUNDRY 07.00-22.00 WITA

Kami ucapkan terima kasih, dan selamat beraktivitas. 

Costumer Care : https://wa.me/6289788786564

Salam hormat, management
GREEN SPIRIT LAUNDRY

''';

// Convert the URL string to a Uri object
    Uri uri = Uri.parse("https://wa.me/$whatsappNumber/?text=${Uri.encodeComponent(message)}");

    try {
      await launchUrl(uri);
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL: $e');
      }
    }

// Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      if (kDebugMode) {
        print("TERKIRIM KOK $uri");
      }
      // Launch the URL
      await launchUrl(uri);
    } else {
      // If unable to launch, display an error message
      if (kDebugMode) {
        print("Could not launch $uri");
      }
    }
  }

  final RxString metodePembayaran = ''.obs;

  void setMetodePembayaran(String? value) {
    metodePembayaran.value = value ?? '';
  }

  RxString selectedPembayaran = "".obs;

  String getSelectedPembayaran() {
    return selectedPembayaran.value;
  }

  void setSelectedPembayaran(String? value) {
    selectedPembayaran.value = value ?? "";
  }

  String formatDate(String date) {
    try {
      // Assuming date is in DD-MM-YYYY format
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate); // Convert to YYYY-MM-DD format
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return "";
    }
  }

  void setStatusCucian(String status) {
    statusCucian.value = status;
  }

  void setStatusPembayaran(String status) {
    statusPembayaran.value = status;
  }
}
