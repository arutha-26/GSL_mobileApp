import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class UpdateDataPelangganController extends GetxController {
  static UpdateDataPelangganController get to => Get.find();

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> updatedUserData = <String, dynamic>{}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<Map<String, dynamic>> getdatapelanggan(Map<String, dynamic> userData) async {
    try {
      var response = await client
          .from("user")
          .select()
          .match({"id": userData['id']}) // Use the correct key from userData
          .execute();

      if (response.status == 200 && response.data != null) {
        List<dynamic> data = response.data as List<dynamic>;
        if (data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
    }
    return {};
  }

  final formKey = GlobalKey<FormState>(); // Use this key consistently

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    print('Update button pressed');
    try {
      if (userData['id'] != null) {
        isLoading.value = true;

        // Prepare the update fields
        Map<String, dynamic> updateFields = {
          "phone": updatedUserData['phone'] ?? userData['phone'],
          "kategori": updatedUserData['kategori'] ?? userData['kategori'],
          "alamat": updatedUserData['alamat'] ?? userData['alamat'],
          "is_active": updatedUserData['is_active'] ?? userData['is_active'],
          "edit_at": DateTime.now().toString(),
        };

        var response = await client
            .from("user")
            .update(updateFields)
            .match({"id": userData['id']}).execute();

        isLoading.value = false; // Reset the loading state

        if (response.status == 200 || response.status == 201 || response.status == 204) {
          Get.snackbar(
            'Success',
            'User data updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Log the updated data to the console
          print('Updated data: $updatedUserData');

          // Navigate back to the data pelanggan page
          Get.offAndToNamed(Routes.DATAPELANGGAN);
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
      print('Error updating user data: $error');
    }
  }
}
