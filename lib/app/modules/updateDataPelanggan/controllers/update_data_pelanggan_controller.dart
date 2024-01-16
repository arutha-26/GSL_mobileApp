import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class UpdateDataPelangganController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> updatedUserData = <String, dynamic>{}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    if (kDebugMode) {
      print('Update button pressed');
    }
    try {
      if (userData['id_user'] != null) {
        isLoading.value = true;

        // Prepare the update fields
        Map<String, dynamic> updateFields = {
          "no_telp": updatedUserData['no_telp'] ?? userData['no_telp'],
          "kategori": updatedUserData['kategori'] ?? userData['kategori'],
          "alamat": updatedUserData['alamat'] ?? userData['alamat'],
          "is_active": updatedUserData['is_active'] ?? userData['is_active'],
          "edit_at": DateTime.now().toString(),
        };

        var response = await client
            .from("user")
            .update(updateFields)
            .match({"id_user": userData['id_user']}).execute();

        isLoading.value = false; // Reset the loading state

        if (response.status == 200 || response.status == 201 || response.status == 204) {
          Get.snackbar(
            'Berhasil', 'Data Berhasil di Perbaharui',
            colorText: Colors.white,
            backgroundColor: Colors.indigoAccent,
            // backgroundColor: const Color(0xFFC9DCD1),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            // padding: const EdgeInsets.all(10) // Set the desired distance from the top
          );

          // Log the updated data to the console
          if (kDebugMode) {
            print('Updated data: $updatedUserData');
          }

          // Navigate back to the data pelanggan page
          Get.forceAppUpdate();
          Get.offAndToNamed(Routes.DETAILPELANGGAN, arguments: userData);
          refresh();
        } else {
          Get.snackbar(
            'Error',
            'Failed to update user data',
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
        print('Error updating user data: $error');
      }
    }
  }
}
