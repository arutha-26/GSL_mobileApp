import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class UpdateDataHargaController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> updatedUserData = <String, dynamic>{}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    if (kDebugMode) {
      print('Update button pressed');
    }
    try {
      if (userData['id'] != null) {
        isLoading.value = true;

        String hargaKilo = updatedUserData['harga_kilo'].toString();
        String cleanedInput = hargaKilo.replaceAll(RegExp(r'[^\d]'), '');

        // Prepare the update fields
        Map<String, dynamic> updateFields = {
          "kategori_pelanggan":
              updatedUserData['kategori_pelanggan'] ?? userData['kategori_pelanggan'],
          "metode_laundry_id":
              updatedUserData['metode_laundry_id'] ?? userData['metode_laundry_id'],
          "layanan_laundry_id":
              updatedUserData['layanan_laundry_id'] ?? userData['layanan_laundry_id'],
          "harga_kilo": cleanedInput,
          "edit_at": DateTime.now().toString(),
        };
        if (kDebugMode) {
          print(updateFields);
        }

        var response = await client
            .from("harga")
            .update(updateFields)
            .match({"id": userData['id']}).execute();

        isLoading.value = false; // Reset the loading state

        if (response.status == 200 || response.status == 201 || response.status == 204) {
          Get.snackbar(
            'Berhasil',
            'Data Berhasil di Perbaharui',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Log the updated data to the console
          if (kDebugMode) {
            print('Data Diperbaharui: $updatedUserData');
          }

          // Navigate back to the data pelanggan page
          Get.offAndToNamed(Routes.PANELTRANSAKSI);
          refresh();
        } else {
          Get.snackbar(
            'Error',
            'Failed to update user data',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (error) {
      isLoading.value = false; // Reset the loading state in case of an error
      if (kDebugMode) {
        print('Error updating user data: $error');
      }
    }
  }
}
