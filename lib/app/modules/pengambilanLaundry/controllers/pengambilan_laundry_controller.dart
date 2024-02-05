import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/pengambilan.dart';

class PengambilanLaundryController extends GetxController {
  TextEditingController roleC = TextEditingController();

  Future<void> getDataKaryawan() async {
    try {
      List<dynamic> res =
          await client.from("user").select('*').match({"uid": client.auth.currentUser!.id});

      if (res.isNotEmpty) {
        Map<String, dynamic> user = res.first as Map<String, dynamic>;
        idKaryawanC.text = user["id_user"].toString();
        roleC.text = user["role"].toString();
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

  @override
  void onInit() {
    super.onInit();
    formatNominal();
    nominalBayarController.addListener(() {
      getKembalian();
    });
    // updateDateFieldVisibility();
    // setupListeners();
  }

  void setupListeners() {
    statusCucianController.addListener(() {
      updateDateFieldVisibility();
    });

    statusPembayaranController.addListener(() {
      updateDateFieldVisibility();
    });
  }

  final RxBool isDateFieldVisible = false.obs;
  final RxBool isUpdateDataLoading = false.obs;
  final RxBool isKirimLoading = false.obs;

  Future<void> updateDateFieldVisibility() async {
    debugPrint('status Cucian: ${statusCucianController.text.toString()}');
    debugPrint('status Pembayaran: ${statusPembayaranController.text.toString()}');

    isUpdateDataLoading.value = true; // Set loading to true while the update is in progress

    await Future.delayed(
        const Duration(seconds: 1)); // Simulate an async operation (replace with actual logic)

    if (statusCucianController.text.toString() == 'Selesai' &&
        statusPembayaranController.text.toString() == 'Belum Lunas') {
      isUpdateDataLoading.value = false; // Set loading to true while the update is in progress
      debugPrint('Is Date Field Visible: ${isDateFieldVisible.value}');
      isDateFieldVisible.value = true;
    } else if (statusCucianController.text.toString() == 'Dalam Proses' &&
        statusPembayaranController.text.toString() == 'Lunas') {
      isUpdateDataLoading.value = false; // Set loading to true while the update is in progress
      debugPrint('Is Date Field Visible: ${isDateFieldVisible.value}');
      isDateFieldVisible.value = true;
    } else if (statusCucianController.text.toString() == 'Dalam Proses' &&
        statusPembayaranController.text.toString() == 'Belum Lunas') {
      isUpdateDataLoading.value = false; // Set loading to true while the update is in progress
      debugPrint('Is Date Field Visible: ${isDateFieldVisible.value}');
      isDateFieldVisible.value = true;
    } else if (statusCucianController.text.toString() == 'Selesai' &&
        statusPembayaranController.text.toString() == 'Lunas') {
      isUpdateDataLoading.value = false; // Set loading to true while the update is in progress
      debugPrint('Is Date Field Visible: ${isDateFieldVisible.value}');
      isDateFieldVisible.value = true;
    } else {
      isDateFieldVisible.value = false;
    }
  }

  void clearInputs() {
    idKaryawanC.clear();
    namaController.clear();
    noTelpController.clear();
    statusPembayaranController.clear();
    statusCucianController.clear();
    idTransaksiController.clear();
    tanggalDiambilController.clear();
    beratLaundryController.clear();
    hargaTotalController.clear();
    nameController.clear();
    phoneController.clear();
    beratController.clear();
    totalHargaController.clear();
    metodePembayaranController.clear();
    tglDatangController.clear();
    refresh();
  }

  @override
  void onClose() {
    // Clear input fields
    clearInputs();
    idKaryawanC.dispose();
    idTransaksiController.dispose();
    nameController.dispose();
    noTelpController.dispose();
    statusPembayaranController.dispose();
    statusCucianController.dispose();
    phoneController.dispose();
    tanggalDiambilController.dispose();
    beratLaundryController.dispose();
    hargaTotalController.dispose();
    metodePembayaranController.dispose();
    tglDatangController.dispose();
    super.onClose();
  }

  RxString statusCucian = ''.obs;
  RxString statusPembayaran = ''.obs;
  RxBool isLoading = false.obs;
  TextEditingController idKaryawanC = TextEditingController();
  TextEditingController tanggalDiambilController = TextEditingController();
  TextEditingController beratLaundryController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController idTransaksiController = TextEditingController();
  TextEditingController idUserController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController totalHargaController = TextEditingController();
  TextEditingController metodePembayaranController = TextEditingController();
  TextEditingController statusPembayaranController = TextEditingController();
  TextEditingController statusCucianController = TextEditingController();
  TextEditingController nominalBayarController = TextEditingController();
  TextEditingController kembalianController = TextEditingController();
  TextEditingController tglDatangController = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  int getNumericValueFromKembalian() {
    String rawValue = kembalianController.text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(rawValue) ?? 0;
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

  // Fungsi untuk mengonversi nilai status_pembayaran
  String convertStatusPembayaran(String status) {
    if (status == 'belum_dibayar') {
      return 'Belum Lunas';
    } else if (status == 'Lunas') {
      return 'Lunas';
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
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, layanan_laundry, metode_laundry, metode_pembayaran, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user!inner(id_user, nama, no_telp, kategori, alamat)')
          .in_('status_cucian', ['Dalam Proses', 'Selesai'])
          .ilike('id_user.nama, id_user.no_telp', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          print(item);
          final idUser = item['id_user']?['id_user'].toString() ?? '';
          final nama = item['id_user']?['nama']?.toString().capitalizeFirst ?? '';
          final noTelp = item['id_user']?['no_telp']?.toString() ?? '';
          final idTransaksi = item['id_transaksi']?.toString() ?? '';
          final berat = item['berat_laundry']?.toString() ?? '';
          final totalHarga = item['total_biaya']?.toString() ?? '';
          final metodePembayaran = item['metode_pembayaran']?.toString() ?? '';
          final statusPembayaran = item['status_pembayaran']?.toString() ?? '';
          final statusCucian = item['status_cucian']?.toString() ?? '';
          final tglDatang = item['tanggal_datang']?.toString() ?? '';

          // Format tanggal
          final formattedDate = tglDatang.isNotEmpty
              ? DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(tglDatang))
              : '';
          // Use a dedicated function to format totalHarga
          final formattedTotalHarga = formatTotalHarga(totalHarga);

          return Pengambilan(
              nama: nama,
              noTelp: noTelp,
              idTransaksi: idTransaksi,
              berat: '${berat}Kg',
              totalHarga: formattedTotalHarga,
              metodePembayaran: metodePembayaran,
              statusPembayaran: statusPembayaran,
              statusCucian: statusCucian,
              idUser: idUser,
              tglDatang: formattedDate);
        }).toList();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
      // Handle the error appropriately based on your application's requirements.
    }
    return results;
  }

  XFile? imagePilih;

  void updateSelectedImage(XFile? image) {
    imagePilih = image;
    if (kDebugMode) {
      print('image data nih sebelum update: $image');
    }
    // Get.appUpdate(); // Perbarui state tanpa memakai Get.forceAppUpdate
    Get.forceAppUpdate(); // Perbarui state
    if (kDebugMode) {
      print('image data nih setelah update: $image');
    }
  }

  String? get selectedImagePath => imagePilih?.path;

  Future<void> updateTransaksi() async {
    String? imgUrlNih;

    if (statusCucian.value.isNotEmpty) {
      isKirimLoading.value = true;

      if (selectedImagePath != null) {
        final imageExtension = selectedImagePath!.split('.').last.toLowerCase();
        final imageBytes = await File(selectedImagePath!).readAsBytes();
        final tanggal = DateTime.now().toString();
        final imagePath = '/$tanggal/bukti';

        await client.storage.from('bukti').uploadBinary(
              imagePath,
              imageBytes,
              fileOptions: FileOptions(
                upsert: true,
                contentType: 'image/$imageExtension',
              ),
            );

        String imageUrl = client.storage.from('bukti').getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();

        imgUrlNih = imageUrl;
      }

      try {
        var dataTransaksi = {};

        if (statusCucian.value == "Diambil" && statusPembayaran.value == "Lunas") {
          dataTransaksi["id_karyawan_keluar"] = idKaryawanC.text;
          dataTransaksi["tanggal_diambil"] =
              formatDateWithCurrentTime(DateTime.now().toString()).toString();
          dataTransaksi["metode_pembayaran"] = getSelectedPembayaran();
          dataTransaksi["status_pembayaran"] = statusPembayaran.value;
          dataTransaksi["status_cucian"] = statusCucian.value;
          dataTransaksi["is_hidden"] = true;
          dataTransaksi["edit_at"] =
              formatDateWithCurrentTime(DateTime.now().toString()).toString();
          dataTransaksi["bukti_transfer"] = imgUrlNih;
        } else if (statusCucian.value == "Diambil") {
          dataTransaksi["id_karyawan_keluar"] = idKaryawanC.text;
          dataTransaksi["tanggal_diambil"] =
              formatDateWithCurrentTime(DateTime.now().toString()).toString();
          dataTransaksi["status_cucian"] = statusCucian.value;
          dataTransaksi["is_hidden"] = true;
          dataTransaksi["edit_at"] =
              formatDateWithCurrentTime(DateTime.now().toString()).toString();
        } else {
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
            .match({"id_transaksi": idTransaksiController.text}).execute();

        // Kirim pesan WhatsApp setelah transaksi berhasil disimpan
        // String nomorPelanggan = phoneController.text;
        // String pesan = '';
        //
        // if (statusCucian.value == "Selesai") {
        //   await kirimPesanWhatsApp(nomorPelanggan, pesan);
        // }

        clearInputs();
        Get.snackbar(
          'Succes',
          'Update Data Berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black87,
          backgroundColor: Colors.greenAccent,
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
        );

        if (roleC.text == 'Karyawan') {
          Get.offAndToNamed(Routes.KARYAWANHOME);
        } else {
          Get.offAndToNamed(Routes.OWNERHOME);
        }
      } catch (e) {
        isKirimLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar(
        'ERROR',
        'Data harus di isi!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      );
      return;
    }
    isKirimLoading.value = false;
    refresh();
  }

  Future<void> kirimPesanWhatsApp(String nomorPelanggan, String pesan) async {
    String whatsappNumber = nomorPelanggan;

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
Status: ${statusPembayaran.value}

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

  void setStatusCucian(String status) {
    statusCucian.value = status;
  }

  void setStatusPembayaran(String status) {
    statusPembayaran.value = status;
  }

  void getKembalian() {
    String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanedInput = cleanedInput.replaceAll('.', '');

    final formattedNominal =
        "Rp${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(double.parse(cleanedInput))}";

    nominalBayarController.value = TextEditingValue(
      text: formattedNominal,
      selection: TextSelection.collapsed(offset: formattedNominal.length),
    );

    String cleanedInput2 = totalHargaController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanedInput2 = cleanedInput2.replaceAll('.', '');

    double nominalHarga = double.parse(cleanedInput) ?? 0.0;

    double totalBiaya = 0.0; // Default value if the parsing fails
    if (cleanedInput2.isNotEmpty) {
      totalBiaya = double.tryParse(cleanedInput2) ?? 0.0;
    }

    if (kDebugMode) {
      print('cleaninput2 value: ${hargaTotalController.text.toString()}');
    }

    double kembalian = nominalHarga - totalBiaya;
    double minus = totalBiaya - nominalHarga;

    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    if (kembalian <= 0) {
      kembalianController.text = "Rp0";
      kembalian = -totalBiaya;
    } else {
      kembalianController.text = currencyFormatter.format(kembalian);
    }

    if (kDebugMode) {
      print(
        "Cleaned Input: $cleanedInput, Nominal Harga: $formattedNominal, Total Biaya: $totalBiaya, Kembalian: $kembalian, globalBiaya: $totalBiaya",
      );
    }
  }
}
