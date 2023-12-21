import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailpaneltransaksiController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> getDataPanelTransaksi(Map<String, dynamic> dataPanel) async {
    try {
      var response =
          await client.from("harga").select().match({"id": dataPanel['id']}).execute();

      if (response.status == 200 && response.data != null && response.data.isNotEmpty) {
        return response.data.first;
      } else {
        print('No data found or bad response');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return {}; // Return an empty map in case of failure
  }

  Future<void> updatePrices(int id, String harga) async {
    try {
      var response = await client.from("harga").update({
        "harga_kilo": harga,
      }).match({"id": id}).execute();

      if (response.status == 200) {
        // handle success
      } else {
        // handle failure
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating data: $error');
      }
    }
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Update Data success",
        middleText: "Data berhasil diupdate",
        actions: [
          OutlinedButton(
              onPressed: () {
                Get.back(); //close dialog
                Get.back(); //close dialog
              },
              child: const Text("OK"))
        ]);
    isLoading.value = false;
  }
}
