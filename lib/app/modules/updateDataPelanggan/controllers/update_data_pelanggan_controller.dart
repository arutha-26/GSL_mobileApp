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
    if (kDebugMode) {
      print('Update button pressed');
    }
    try {
      if (userData['id'] != null) {
        isLoading.value = true;

        // Prepare the update fields
        Map<String, dynamic> updateFields = {
          "phone": updatedUserData['phone'],
          "kategori": updatedUserData['kategori'],
          "alamat": updatedUserData['alamat'],
          "edit_at": DateTime.now().toString(),
        };
        if (kDebugMode) {
          print("data update$updatedUserData");
        }

        // Replace empty fields with the corresponding values from userData
        updateFields.forEach((key, value) {
          if (value == null || value.isEmpty) {
            updateFields[key] = userData[key];
          }
        });

        var response = await client
            .from("user")
            .update(updateFields)
            .match({"id": userData['id']}).execute();

        isLoading.value = false; // Reset the loading state
        // Debugging: Print the response status code
        if (kDebugMode) {
          print('Response status code: ${response.status}');
        }
        if (response.status == 200 || response.status == 201 || response.status == 204) {
          Get.snackbar(
            'Success',
            'User data updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Log the updated data to the console
          if (kDebugMode) {
            print('Updated data: $updatedUserData');
          }

          // Navigate back to the data pelanggan page
          Get.offAndToNamed(Routes.DATAPELANGGAN);
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

      // Print the specific error message for further investigation
    }
  }
}
