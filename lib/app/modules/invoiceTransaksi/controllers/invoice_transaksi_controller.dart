import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/invoiceData.dart';
import '../../../utils/pelanggan.dart';

class InvoiceTransaksiController extends GetxController {
  void clearInputs() {
    namaKaryawanC.clear();
    nameController.clear();
    tanggalDatangController.clear();
  }

  @override
  void onClose() {
    clearInputs();
    namaKaryawanC.dispose();
    nameController.dispose();
    tanggalDatangController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchDataTransaksi();
    isLoading.value = false;
  }

  RxBool isLoading = false.obs;
  TextEditingController namaKaryawanC = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController alamatPelangganController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController tanggalDatangController = TextEditingController();
  TextEditingController jatuhTempoController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
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

  RxList<InvoiceData> invoiceData = <InvoiceData>[].obs;
  Rx<DateTime> startDate = Rx(DateTime.now());
  Rx<DateTime> endDate = Rx(DateTime.now());

  Future<void> fetchDataTransaksi() async {
    // Get values from controllers
    String namaPelanggan = nameController.text;
    String startDateText = startDateController.text;
    String endDateText = endDateController.text;

    // Parse text into DateTime objects
    DateTime startDateFormatted = parseDate(startDateText);
    DateTime endDateFormatted = parseDate(endDateText);

    try {
      // Perform data fetching for transaksi
      final transaksiResponse = await client
          .from('transaksi')
          .select()
          .eq('nama_pelanggan', namaPelanggan)
          .gte('tanggal_datang', formatDatetwo(startDateFormatted)) // Adjust as needed
          .lte('tanggal_datang', formatDatetwo(endDateFormatted)) // Adjust as needed
          .execute();

      // Perform data fetching for user
      final userResponse =
          await client.from('user').select('alamat').eq('nama', namaPelanggan).execute();

      if (userResponse.status == 200 &&
          userResponse.data != null &&
          userResponse.data is List) {
        // Set the alamatPelangganController value
        alamatPelangganController.text = (userResponse.data?.first['alamat'] as String?) ?? '';
      } else {
        // Handle the case where user data is not available
        alamatPelangganController.text = '';
      }

      if (kDebugMode) {
        print('Start Date: $startDateFormatted');
        print('End Date: $endDateFormatted');
        print('Start Date: $startDateController.value');
        print('End Date: $endDateController.value');
        print('user data nih:$alamatPelangganController');
      }

      if (transaksiResponse.status == 200 &&
          transaksiResponse.data != null &&
          transaksiResponse.data is List) {
        // Handle the fetched transaksi data
        invoiceData.assignAll((transaksiResponse.data as List).map((transaksiItem) {
          // Process transaksi data as needed
          // Combine transaksi data with user data
          final userData = userResponse.data?.first ?? {};
          return InvoiceData.fromMap(transaksiItem);
        }).toList());

        if (invoiceData.isNotEmpty) {
          if (kDebugMode) {
            print('Fetched data successfully:');
          }
          for (var data in invoiceData) {
            if (kDebugMode) {
              print('Transaction ID: ${data.idTransaksi}');
            }
          }
        } else {
          if (kDebugMode) {
            print('No data found for the specified criteria.');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error fetching transaksi data. Response status: ${transaksiResponse.status}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching transaction data: $error');
      }
    }
  }

  DateTime parseDate(String date) {
    try {
      // Assuming date is in 'yyyy-MM-dd' format
      return DateTime.parse(date);
    } catch (e) {
      // Handle parsing error
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return DateTime.now(); // Default to current date if parsing fails
    }
  }

  String formatDatetwo(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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
}
