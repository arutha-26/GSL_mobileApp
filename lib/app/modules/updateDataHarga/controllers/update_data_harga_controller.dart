import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDataHargaController extends GetxController {
  // @override
  // void onInit() {
  //   Get.lazyPut(() => UpdateDataHargaController());
  //   super.onInit();
  // }

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> updatedUserData = <String, dynamic>{}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    if (kDebugMode) {
      print('Update button pressed');
    }
    try {
      if (userData['id_harga'] != null) {
        isLoading.value = true;

        String cleanedInput =
            updatedUserData['harga_kilo'].toString().replaceAll(RegExp(r'[^\d]'), '');

// Cek apakah cleanedInput kosong setelah menghilangkan karakter non-digit
        double? hargaKilo = cleanedInput.isEmpty ? null : double.parse(cleanedInput);

        // Prepare the update fields
        Map<String, dynamic> updateFields = {
          // "kategori_pelanggan":
          //     updatedUserData['kategori_pelanggan'] ?? userData['kategori_pelanggan'],
          // "metode_laundry_id":
          //     updatedUserData['metode_laundry_id'] ?? userData['metode_laundry_id'],
          // "layanan_laundry_id":
          //     updatedUserData['layanan_laundry_id'] ?? userData['layanan_laundry_id'],
          "harga_kilo": hargaKilo ?? userData['harga_kilo'],
          "edit_at": DateTime.now().toString(),
        };
        if (kDebugMode) {
          print(updateFields);
        }

        var response = await client
            .from("harga")
            .update(updateFields)
            .match({"id_harga": userData['id_harga']}).execute();

        isLoading.value = false; // Reset the loading state

        if (response.status == 200 || response.status == 201 || response.status == 204) {
          // Log the updated data to the console
          if (kDebugMode) {
            print('Data Diperbaharui: $updatedUserData');
          }

          Get.back();
          Get.forceAppUpdate();
          Get.snackbar(
            'Berhasil',
            'Data Berhasil di Perbaharui',
            colorText: Colors.white,
            backgroundColor: Colors.indigoAccent,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
          );
        } else {
          Get.snackbar(
            'Error',
            'Gagal Memperbaharui Data Harga',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (error) {
      isLoading.value = false; // Reset the loading state in case of an error
      if (kDebugMode) {
        print('Gagal Memperbaharui Data Harga: $error');
        Get.snackbar(
          'Error',
          '$error',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
