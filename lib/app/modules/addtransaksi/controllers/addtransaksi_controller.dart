import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/pelanggan.dart';

class AddtransaksiController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    beratLaundryController.addListener(() {
      hitungTotalHarga();
    });
    nominalBayarController.addListener(getKembalian);
    nominalBayarController.addListener(() {
      formattedNominal.value = formatNumber(nominalBayarController.text);
    });
    // Anda bisa menambahkan listener lain di sini
  }

  void clearInputs() {
    namaKaryawanC.clear();
    tanggalDatangController.clear();
    tanggalSelesaiController.clear();
    beratLaundryController.clear();
    hargaTotalController.clear();
    nameController.clear();
    phoneController.clear();
    kategoriController.clear();
    nominalBayarController.clear();
    kembalianController.clear();
    selectedMetode.value = "";
    selectedLayanan.value = "";
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
    tanggalDatangController.dispose();
    tanggalSelesaiController.dispose();
    beratLaundryController.dispose();
    hargaTotalController.dispose();
    nameController.dispose();
    phoneController.dispose();
    kategoriController.dispose();
    nominalBayarController.dispose();
    kembalianController.dispose();
    beratLaundryController.removeListener(() {});
    nominalBayarController.removeListener(getKembalian);
    // Hapus listener lain jika ada
    super.onClose();
  }

  RxDouble numericTotalHarga = 0.0.obs; // Add this line
  RxString statusCucian = 'diproses'.obs;
  RxString statusPembayaran = 'belum_dibayar'.obs;
  RxBool isLoading = false.obs;
  TextEditingController namaKaryawanC = TextEditingController();
  TextEditingController tanggalDatangController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();
  TextEditingController beratLaundryController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController nominalBayarController = TextEditingController();
  TextEditingController kembalianController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<List<Pelanggan>> fetchdataPelanggan(String query) async {
    List<Pelanggan> results = [];
    try {
      final response = await client
          .from('user')
          .select('nama, id, phone, kategori') // Include 'phone' in the select statement
          .eq('role', 'Pelanggan')
          .ilike('nama, phone, kategori', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          // Ensure that 'nama', 'id', and 'phone' are treated as strings
          final nama = item['nama']?.toString() ?? '';
          final id = item['id']?.toString() ?? '';
          final phone = item['phone']?.toString() ?? '';
          final kategori = item['kategori']?.toString() ?? '';

          return Pelanggan(nama: nama, id: id, phone: phone, kategori: kategori);
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

  int getNumericValueFromKembalian() {
    String rawValue = kembalianController.text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(rawValue) ?? 0;
  }

  Future<void> addTransaksi() async {
    if (namaKaryawanC.text.isNotEmpty &&
        beratLaundryController.text.isNotEmpty &&
        hargaTotalController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        var dataTransaksi = {
          "nama_karyawan_masuk": namaKaryawanC.text,
          "tanggal_datang": formatDate(tanggalDatangController.text),
          "tanggal_selesai": formatDate(tanggalSelesaiController.text),
          "tanggal_diambil": null,
          "berat_laundry": double.tryParse(beratLaundryController.text),
          "total_biaya": numericTotalHarga.value,
          "nama_pelanggan": nameController.text,
          "nomor_pelanggan": phoneController.text,
          "kategori_pelanggan": kategoriController.text,
          "metode_laundry": getSelectedMetode(),
          "layanan_laundry": getSelectedLayanan(),
          "metode_pembayaran": getSelectedPembayaran(),
          "nominal_bayar": nominalBayarController.text,
          "kembalian": getNumericValueFromKembalian(),
          "status_pembayaran": statusPembayaran.value,
          "status_cucian": statusCucian.value,
          "created_at": DateTime.now().toIso8601String(),
          "is_hidden": false,
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

  RxString selectedMetode = "".obs;
  List<String> metodeOptions = ["Regular", "Express"];

  String getSelectedMetode() {
    return selectedMetode.value;
  }

  void setSelectedMetode(String? value) {
    selectedMetode.value = value ?? "-";
  }

  RxString selectedLayanan = "".obs;
  List<String> layananOptions = ["Cuci Setrika", "Cuci Saja", "Setrika Saja"];

  String getSelectedLayanan() {
    return selectedLayanan.value;
  }

  void setSelectedLayanan(String? value) {
    selectedLayanan.value = value ?? "";
  }

  RxString selectedPembayaran = "".obs;
  List<String> pembayaranOptions = ["-", "Tunai", "Transfer"];

  String getSelectedPembayaran() {
    return selectedPembayaran.value;
  }

  void setSelectedPembayaran(String? value) {
    selectedPembayaran.value = value ?? "";
  }

  void hitungTotalHarga() async {
    double berat = double.tryParse(beratLaundryController.text) ?? 0.0;
    double hargaPerKg = await ambilHargaPerKg(
        kategoriPelanggan: kategoriController.text,
        metodeLaundry: selectedMetode.value,
        layananLaundry: selectedLayanan.value);
    double totalHarga = berat * hargaPerKg;

    // Store numeric value
    numericTotalHarga.value = totalHarga;

    // Format and display
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 3);
    hargaTotalController.text = currencyFormatter.format(totalHarga);
  }

  RxString formattedNominalBayar = 'Rp. 0,000'.obs;

  void updateFormattedNominalBayar(String value) {
    formattedNominalBayar.value = formatCurrency(value);
  }

  String formatCurrency(String value) {
    if (value.isEmpty) return 'Rp. 0,000';

    // Assuming the input is a valid number
    final number = int.tryParse(value) ?? 0;
    final format = NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
    return '${format.format(number)},000';
  }

  RxString formattedNominal = '0.000'.obs;

  String get formatNominal {
    final input = nominalBayarController.text;
    return input.isEmpty ? '0.000' : '$input.000';
  }

  String formatNumber(String value) {
    return value.isEmpty ? '0.000' : '$value.000';
  }

  void getKembalian() {
    if (kDebugMode) {
      print("getKembalian called");
    } // Debugging log

    // Strip non-numeric characters except the decimal point
    String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
    double nominalHarga = double.tryParse(cleanedInput) ?? 0.0;

    double totalBiaya = numericTotalHarga.value;
    double kembalian = nominalHarga - totalBiaya;
    double minus = totalBiaya - nominalHarga;

    // Custom formatter for Indonesian Rupiah
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 3);

    // Handle negative kembalian (underpayment)
    if (kembalian < 0) {
      // Update kembalianController with an error message
      kembalianController.text = "Pembayaran Kurang: ${currencyFormatter.format(minus)}";
      // Optionally, show a snackbar or dialog for user feedback
      return;
    }

    // Format and display kembalian
    kembalianController.text = currencyFormatter.format(kembalian);

    if (kDebugMode) {
      print("Nominal Harga: $nominalHarga, Total Biaya: $totalBiaya, Kembalian: $kembalian");
    } // Debugging log
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

  Future<double> ambilHargaPerKg(
      {required String kategoriPelanggan,
      required String metodeLaundry,
      required String layananLaundry}) async {
    double harga = 0.0;

    final response = await client
        .from('harga')
        .select('harga_kilo')
        .eq('kategori_pelanggan', kategoriPelanggan)
        .eq('metode_laundry_id', metodeLaundry)
        .eq('layanan_laundry_id', layananLaundry)
        .single()
        .execute();
    if (response.status == 200 && response.data != null) {
      var hargaKilo = response.data['harga_kilo'];
      // Konversi hargaKilo menjadi double
      harga = (hargaKilo is int) ? hargaKilo.toDouble() : hargaKilo;
    }

    return harga;
  }

  void setStatusCucian(String status) {
    statusCucian.value = status;
  }

  void setStatusPembayaran(String status) {
    statusPembayaran.value = status;
  }
}
