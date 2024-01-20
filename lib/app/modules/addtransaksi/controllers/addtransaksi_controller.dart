import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/pelanggan.dart';

class AddtransaksiController extends GetxController {
  XFile? imagePilih;

  void updateSelectedImage(XFile? image) {
    imagePilih = image;
    print('image data nih sebelum update: $image');
    // Get.appUpdate(); // Perbarui state tanpa memakai Get.forceAppUpdate
    Get.forceAppUpdate(); // Perbarui state
    print('image data nih setelah update: $image');
  }

  String? get selectedImagePath => imagePilih?.path;

  Future<void> addTransaksi() async {
    if (selectedImagePath != null) {
      isLoading.value = true;

      String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
      cleanedInput = cleanedInput.replaceAll('.', '');
      String? imgUrlNih;
      if (selectedImagePath != null) {
        print('image path nih: $selectedImagePath');
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
        // addTransaksi();
      }

      try {
        var dataTransaksi = {
          "id_karyawan_masuk": idKaryawanC.text.toString(),
          "tanggal_datang": DateTime.now().toString(),
          "tanggal_selesai":
              formatDateWithCurrentTime(tanggalSelesaiController.text).toString(),
          "tanggal_diambil": null,
          "berat_laundry": double.tryParse(beratLaundryController.text),
          "total_biaya": numericTotalHarga.value.toStringAsFixed(0),
          "id_user": idUserController.text,
          "metode_laundry": getSelectedMetode(),
          "layanan_laundry": getSelectedLayanan(),
          "metode_pembayaran": getSelectedPembayaran(),
          "nominal_bayar": cleanedInput,
          "kembalian": getNumericValueFromKembalian(),
          "status_pembayaran": statusPembayaran.value,
          "status_cucian": 'diproses',
          "created_at": DateTime.now().toString(),
          "is_hidden": false,
          "bukti_transfer": imgUrlNih,
        };

        if (kDebugMode) {
          print("Data to be inserted into transaksi: $dataTransaksi");
        }

        await client.from("transaksi").insert(dataTransaksi).execute();

        await generateAndOpenInvoicePDF(dataTransaksi);

        clearInputs();

        Get.defaultDialog(
          barrierDismissible: true,
          title: "Berhasil",
          middleText: "Transaksi berhasil ditambahkan\n Berhasil Cetak Faktur",
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                Get.offAndToNamed(Routes.OWNERHOME);
              },
              child: const Text("OK"),
            ),
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

  @override
  void onInit() {
    super.onInit();
    beratLaundryController.addListener(() {
      hitungTotalHarga();
    });
    formatNominal();
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
  TextEditingController namaKaryawanC = TextEditingController();
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
          await client.from("user").select('*').match({"uid": client.auth.currentUser!.id});

      if (res.isNotEmpty) {
        Map<String, dynamic> user = res.first as Map<String, dynamic>;
        idKaryawanC.text = user["id_user"].toString();
        namaKaryawanC.text = user["nama"].toString();
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

  Future<void> generateAndOpenInvoicePDF(data) async {
    String formatCurrency(double value) {
      final currencyFormat =
          NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(value);
      return currencyFormat;
    }

    String formatDate(String date) {
      try {
        // Assuming date is in YYYY-MM-DD format
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
        return DateFormat('dd-MM-yyyy').format(parsedDate); // Convert to YYYY-MM-DD format
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing date: $e");
        }
        return "";
      }
    }

    String cleanedInput = nominalBayarController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanedInput = cleanedInput.replaceAll('.', '');

    final pdf = pw.Document();

    // Helper function to create a styled text row
    pw.Widget styledTextRow(String label, String value) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 10),
          pw.Text(value),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(8 * PdfPageFormat.cm, 20 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm),
        build: (context) => [
          // pw.Center(
          //   child: pw.Text(
          //     'Id F: ${data['id_transaksi']?.toString() ?? '-'}',
          //     style: pw.TextStyle(
          //       fontWeight: pw.FontWeight.bold,
          //     ),
          //   ),
          // ),
          // pw.Divider(
          //     height: 1,
          //     borderStyle: pw.BorderStyle.solid,
          //     thickness: 1,
          //     color: PdfColors.black),
          // pw.SizedBox(height: 5),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Green Spirit Laundry',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                  'Jl. Pura Masuka Gg. Jepun, Ungasan,\nKec. Kuta Sel., Kabupaten Badung, Bali 80361',
                  textAlign: pw.TextAlign.center),
              pw.Text('Telp (+6281 23850 7062)'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Customer Data',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  nameController.text.toString().capitalizeFirst ?? '-',
                  overflow: pw.TextOverflow.visible, // Truncate with ellipsis if too long
                ),
                pw.Text(
                  phoneController.text.toString() ?? '-',
                  overflow: pw.TextOverflow.visible, // Truncate with ellipsis if too long
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 5),
                pw.Text('Detail Transaksi',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                styledTextRow('Tanggal:', formatDate(data['tanggal_datang']) ?? '-'),
                styledTextRow('Metode Laundry:',
                    data['metode_laundry']?.toString().capitalizeFirst ?? '-'),
                styledTextRow('Layanan Laundry:',
                    data['layanan_laundry']?.toString().capitalizeFirst ?? '-'),
                styledTextRow('Berat Laundry:', '${data['berat_laundry']}Kg' ?? '-'),
                styledTextRow('Status Cucian:', data['status_cucian']?.toString() ?? '-'),
                styledTextRow(
                    'Status Pembayaran:',
                    data['status_pembayaran']?.toString() == 'sudah_dibayar'
                        ? 'Sudah Dibayar'
                        : 'Belum Dibayar' ?? '-'),
                styledTextRow('Total Biaya:',
                    formatCurrency(double.tryParse(data['total_biaya'].toString()) ?? 0.0)),
                styledTextRow('Nominal Bayar:', nominalBayarController.text),
                styledTextRow('Kembalian:',
                    formatCurrency(double.tryParse(data['kembalian'].toString()) ?? 0.0)),
              ]),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Catatan:\n 1. Pembayaran dapat dilakukan melalui transfer ke rekening\n A/N Green Spirit Laundry di BCA dengan nomor xxx.xxx.xxxx.\n '
                '2. Keterlambatan pembayaran akan dikenakan bunga.\n 3. Hubungi kami jika ada kendala atau pertanyaan.\n'
                'CP: Green Spirit Laundry - +62897913414121121',
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                    pw.Text(namaKaryawanC.text.capitalizeFirst ?? '-'),
                    pw.SizedBox(height: 50),
                    pw.Text('Karyawan Green Spirit Laundry'),
                  ],
                ),
              ])
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
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
