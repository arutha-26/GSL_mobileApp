import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/invoiceData.dart';

class InvoiceTransaksiDataController extends GetxController {
  RxList<InvoiceData> invoiceData = <InvoiceData>[].obs;
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

  Future<void> fetchDataTransaksi() async {
    // Get values from controllers
    String namaPelanggan = nameController.text;
    String tanggalTransaksi = tanggalSelesaiController.text;

    try {
      isLoading.value = true;
      final response = await client
          .from('transaksi') // replace with your actual transaction table name
          .select()
          .eq('nama_pelanggan', namaPelanggan)
          .eq('tanggal_datang', tanggalTransaksi)
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        // Handle the fetched data
        invoiceData.assignAll((response.data as List).map((item) {
          return InvoiceData.fromMap(item);
        }).toList());
      }

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      if (kDebugMode) {
        print('Exception during fetching transaction data: $error');
      }
    }
  }
}
