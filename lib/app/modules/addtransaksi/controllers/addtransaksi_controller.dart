import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/pelanggan.dart';

class AddtransaksiController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    beratLaundryController.addListener(() {
      hitungTotalHarga();
    });
    formatNominal();
    // nominalBayarController.addListener(getKembalian);
    nominalBayarController.addListener(() {
      getKembalian();
    });
  }

  void clearInputs() {
    idKaryawanC.clear();
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
    // Get.
    // Clear input fields
    clearInputs();

    // Dispose of TextEditingControllers
    idKaryawanC.dispose();
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
  RxDouble numericHargaKilo = 0.0.obs; // Add this line
  RxString statusCucian = 'diproses'.obs;
  RxString statusPembayaran = 'belum_dibayar'.obs;
  RxBool isLoading = false.obs;
  TextEditingController idKaryawanC = TextEditingController();
  TextEditingController tanggalDatangController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();
  TextEditingController beratLaundryController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController hargaKiloController = TextEditingController();
  TextEditingController nominalBayarController = TextEditingController();
  TextEditingController kembalianController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  TextEditingController idUserController = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<List<Pelanggan>> fetchdataPelanggan(String query) async {
    List<Pelanggan> results = [];
    try {
      final response = await client
          .from('user')
          .select(
              'nama, id_user, no_telp, kategori') // Include 'phone' in the select statement
          .eq('role', 'Pelanggan')
          .ilike('nama, no_telp, kategori', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          // Ensure that 'nama', 'id', and 'phone' are treated as strings
          final nama = item['nama']?.toString() ?? '';
          final id = item['id_user']?.toString() ?? '';
          final phone = item['no_telp']?.toString() ?? '';
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
    try {
      List<dynamic> res =
          await client.from("user").select().match({"uid": client.auth.currentUser!.id});

      if (res.isNotEmpty) {
        Map<String, dynamic> user = res.first as Map<String, dynamic>;
        idKaryawanC.text = user["id_user"].toString();
      } else {
        if (kDebugMode) {
          print("Data not found for current user ID");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    }
  }

  int getNumericValueFromKembalian() {
    String rawValue = kembalianController.text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(rawValue) ?? 0;
  }

  Future<void> addTransaksi() async {
    if (beratLaundryController.text.isNotEmpty && hargaTotalController.text.isNotEmpty) {
      isLoading.value = true;

      String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
      cleanedInput = cleanedInput.replaceAll('.', '');

      try {
        var dataTransaksi = {
          "id_karyawan_masuk": idKaryawanC.text.toString(),
          "tanggal_datang": formatDateWithCurrentTime(tanggalDatangController.text).toString(),
          "tanggal_selesai":
              formatDateWithCurrentTime(tanggalSelesaiController.text).toString(),
          "tanggal_diambil": null,
          "berat_laundry": double.tryParse(beratLaundryController.text),
          "total_biaya":
              numericTotalHarga.value.toStringAsFixed(0), // Round to 0 decimal places
          "id_user": idUserController.text,
          "metode_laundry": getSelectedMetode(),
          "layanan_laundry": getSelectedLayanan(),
          "metode_pembayaran": getSelectedPembayaran(),
          "nominal_bayar": cleanedInput,
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

        // Kirim pesan WhatsApp setelah transaksi berhasil disimpan
        String nomorPelanggan = phoneController.text;
        String pesan = '';

        await kirimPesanWhatsApp(nomorPelanggan, pesan);

        clearInputs();

        Get.defaultDialog(
          barrierDismissible: true,
          title: "Tambah Data Transaksi Berhasil",
          middleText: "Transaksi berhasil ditambahkan\n Faktur Berhasil Terkirim",
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text("OK"),
            )
          ],
        );
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'ERROR',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } else {
      Get.snackbar(
        'ERROR',
        "Seluruh data harus terisi!",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
    isLoading.value = false;
    refresh();
  }

  RxString selectedMetode = "".obs;

  String getSelectedMetode() {
    return selectedMetode.value;
  }

  void setSelectedMetode(String? value) {
    selectedMetode.value = value ?? "-";
  }

  RxString selectedLayanan = "".obs;

  String getSelectedLayanan() {
    return selectedLayanan.value;
  }

  void setSelectedLayanan(String? value) {
    selectedLayanan.value = value ?? "";
  }

  RxString selectedPembayaran = "".obs;

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
    numericHargaKilo.value = hargaPerKg;

    // Format and display
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    hargaTotalController.text = currencyFormatter.format(totalHarga);
    // Display the numeric value in hargaKiloController
    hargaKiloController.text = hargaPerKg.toString();
  }

  formatNominal() {
    nominalBayarController.addListener(() {
      final value = nominalBayarController.text;

      if (value.isEmpty) {
        return; // Tidak perlu format jika nilai kosong
      }

      // Hapus semua karakter non-digit
      final cleanedInput = value.replaceAll(RegExp(r'[^\d]'), '');

      // Periksa apakah nilai kosong setelah membersihkan karakter
      if (cleanedInput.isEmpty) {
        return; // Tidak perlu format jika nilai kosong setelah membersihkan karakter
      }

      final number = int.tryParse(cleanedInput); // Menggunakan int.tryParse

      if (number != null) {
        final formattedValue =
            NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(number);
        if (value != formattedValue) {
          nominalBayarController.value = TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(offset: formattedValue.length),
          );
        }
      }
    });
  }

  void getKembalian() {
    String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Remove the dot from cleaned input
    cleanedInput = cleanedInput.replaceAll('.', '');

    // Use the cleaned input for formatting Nominal Harga
    final formattedNominal =
        "Rp${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(double.parse(cleanedInput))}";

    // Display the formatted Nominal Harga
    nominalBayarController.value = TextEditingValue(
      text: formattedNominal,
      selection: TextSelection.collapsed(offset: formattedNominal.length),
    );

    // Use the cleaned input for calculations
    double nominalHarga = double.parse(cleanedInput) ?? 0.0;
    double totalBiaya = numericTotalHarga.value;
    double kembalian = nominalHarga - totalBiaya;
    double minus = totalBiaya - nominalHarga;

    // Custom formatter for Indonesian Rupiah
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    // Handle negative kembalian (underpayment)
    if (kembalian <= 0) {
      // Update kembalianController with an error message
      kembalianController.text = "Rp0";
      sisaTagihan = currencyFormatter.format(totalBiaya);

      // Optionally, show a snackbar or dialog for user feedback

      // Set a constant Kembalian value
      kembalian = -totalBiaya;
    } else {
      sisaTagihan = "Rp0";
      // Format and display kembalian
      kembalianController.text = currencyFormatter.format(kembalian);
    }

    // Debugging log
    if (kDebugMode) {
      print(
          "Cleaned Input: $cleanedInput, Nominal Harga: $formattedNominal, Total Biaya: $totalBiaya, Kembalian: $kembalian");
    }
  }

  String formatDateWithCurrentTime(String date) {
    try {
      // Get current date and time
      DateTime now = DateTime.now();

      // Format the date with current time
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      return formattedDate;
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting date with current time: $e");
      }
      return "";
    }
  }

  String formatDate(String date) {
    try {
      // Assuming date is in DD-MM-YYYY HH:mm:ss format
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);

      // Convert to local time zone
      DateTime localDate = parsedDate.toLocal();

      return DateFormat('yyyy-MM-dd').format(localDate);
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

  String sisaTagihan = "Error";

  Future<void> kirimPesanWhatsApp(String nomorPelanggan, String pesan) async {
    String whatsappNumber = '+62$nomorPelanggan'; // Replace with the actual WhatsApp number

    String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanedInput = cleanedInput.replaceAll('.', '');

    // Format numericHargaKilo.value as "Rp x.xxx"
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    String formattedHargaKilo = currencyFormatter.format(numericHargaKilo.value);
    String generateRandomNotaNumber() {
      // Generate a random 12-digit number
      Random random = Random();
      int randomNumber = random.nextInt(10000);

      // Format the random number as a string with leading zeros if necessary
      String formattedNumber = randomNumber.toString().padLeft(8, '0');

      return formattedNumber;
    }

    String message = '''
FAKTUR ELEKTRONIK

GREEN SPIRIT LAUNDRY
Jl. UNGASAN
089788786564

Pelanggan Yth,
${(nameController.text).capitalizeFirst}

Nomor Nota:
${generateRandomNotaNumber()}

Terima:
${tanggalDatangController.text}
Selesai: 
${tanggalSelesaiController.text}

=================
Detail pesanan:
Kiloan, ${beratLaundryController.text}KG X $formattedHargaKilo = ${hargaTotalController.text}

Ket: 
=================
Detail biaya :
Total tagihan : ${hargaTotalController.text}
Metode Laundry : ${selectedMetode.value}
Layanan Laundry : ${selectedLayanan.value}
Grand total : ${hargaTotalController.text}
Nominal Bayar : ${nominalBayarController.text}
Kembalian : ${kembalianController.text}
Status Pembayaran: ${statusPembayaran.value = (statusPembayaran.value == "sudah_dibayar") ? "Sudah Dibayar" : "Belum Dibayar"}
Sisa Tagihan : ${sisaTagihan.toString()}

Status Cucian: ${statusCucian.value = (statusCucian.value = (statusCucian.value == "diproses") ? "Diproses" : (statusCucian.value == "selesai") ? "Selesai" : (statusCucian.value == "diambil") ? "Diambil" : "Status Tidak Valid")}

Costumer Care : https://wa.me/6281933072799
=================
Syarat & ketentuan:
PERHATIAN :
1. Pengambilan barang harap disertai Nota.
2. Barang yang tidak diambil selama 1 Minggu, hilang / rusak bukan tanggung jawab laundry.
3. Barang hilang/rusak karena proses pengerjaan diganti rugi maksimal 5x dari biaya jasa cuci barang yang rusak/hilang.
4. Pakaian luntur bukan menjadi tanggung jawab kami.
5. Cek kelengkapan Laundry-an anda terlebih dahulu sebelum meninggalkan outlet, karena setelah meninggalkan outlet kami tidak menerima komplain.
6. Setiap konsumen dianggap setuju dengan isi syarat & peraturan laundry kami.
=================

Terima kasih
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
}
