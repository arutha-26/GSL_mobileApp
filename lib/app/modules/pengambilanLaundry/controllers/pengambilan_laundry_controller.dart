import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/pengambilan.dart';

class PengambilanLaundryController extends GetxController {

  void clearInputs() {
    namaKaryawanC.clear();
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

    // Dispose of TextEditingControllers
    namaKaryawanC.dispose();
    tanggalDiambilController.dispose();
    beratLaundryController.dispose();
    hargaTotalController.dispose();
    nameController.dispose();
    beratLaundryController.removeListener(() {});
    // Hapus listener lain jika ada
    super.onClose();
  }

  RxString statusCucian = 'diproses'.obs;
  RxString statusPembayaran = 'belum_dibayar'.obs;
  RxBool isLoading = false.obs;
  TextEditingController namaKaryawanC = TextEditingController();
  TextEditingController tanggalDiambilController = TextEditingController();
  TextEditingController beratLaundryController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController totalHargaController = TextEditingController();
  TextEditingController metodePembayaranController = TextEditingController();
  TextEditingController statusPembayaranController = TextEditingController();
  TextEditingController statusCucianController = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<List<Pengambilan>> fetchDataTransaksi(String query) async {
    List<Pengambilan> results = [];
    try {
      final response = await client
          .from('transaksi')
          .select(
              'nama_pelanggan, transaksi_id, nomor_pelanggan, berat_laundry, total_biaya, metode_pembayaran, status_pembayaran, status_cucian') // Include 'phone' in the select statement
          .ilike('nama_pelanggan, nomor_pelanggan', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          // Ensure that 'nama', 'id', and 'phone' are treated as strings
          final nama = item['nama_pelanggan']?.toString() ?? '';
          final id = item['id_transaksi']?.toString() ?? '';
          final phone = item['nomor_pelanggan']?.toString() ?? '';
          final berat = item['berat_laundry']?.toString() ?? '';
          final totalHarga = item['total_biaya']?.toString() ?? '';
          final metodePembayaran = item['metode_pembayaran']?.toString() ?? '';
          final statusPembayaran = item['status_pembayaran']?.toString() ?? '';
          final statusCucian = item['status_cucian']?.toString() ?? '';

          return Pengambilan(
              nama: nama,
              id: id,
              phone: phone,
              berat: berat,
              totalHarga: totalHarga,
              metodePembayaran: metodePembayaran,
              statusPembayaran: statusPembayaran,
              statusCucian: statusCucian);
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
    if (namaKaryawanC.text.isNotEmpty &&
        beratLaundryController.text.isNotEmpty &&
        hargaTotalController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        var dataTransaksi = {
          "nama_karyawan_keluar": namaKaryawanC.text,
          "tanggal_diambil": formatDate(tanggalDiambilController.text),
          "metode_pembayaran": getSelectedPembayaran(),
          "status_pembayaran": statusPembayaran.value,
          "status_cucian": statusCucian.value,
          "is_active": false,
        };

        // Log the dataTransaksi to the console
        if (kDebugMode) {
          print("Data to be inserted into transaksi: $dataTransaksi");
        }

        await client.from("transaksi").insert(dataTransaksi).execute();

        clearInputs();

        Get.defaultDialog(
            barrierDismissible: false,
            title: "Tambah Data Transaksi Berhasil",
            middleText: "Transaksi berhasil ditambahkan.",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text("OK"))
            ]);
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


  RxString selectedPembayaran = "".obs;
  List<String> pembayaranOptions = ["-", "Cash", "Transfer"];

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
