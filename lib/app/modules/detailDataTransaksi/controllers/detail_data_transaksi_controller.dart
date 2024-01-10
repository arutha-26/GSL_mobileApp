import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailDataTransaksiController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> getDataTransaksi(Map<String, dynamic> dataPanel) async {
    try {
      var response = await client
          .from("transaksi")
          .select()
          .match({"transaksi_id": dataPanel['transaksi_id']}).execute();

      if (response.status == 200 && response.data != null && response.data.isNotEmpty) {
        return response.data.first;
      } else {
        if (kDebugMode) {
          print('No data found or bad response');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    }
    return {}; // Return an empty map in case of failure
  }
}
