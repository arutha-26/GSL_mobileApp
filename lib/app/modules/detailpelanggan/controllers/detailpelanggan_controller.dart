import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class DetailpelangganController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> getdatapelanggan(Map<String, dynamic> userData) async {
    try {
      if (userData['id'] != null) {
        var response = await client
            .from("user")
            .select()
            .match({"id": userData['id'].toString()}) // Convert to string if necessary
            .execute();

        if (response.status == 200 && response.data != null) {
          List<dynamic> data = response.data as List<dynamic>;
          if (data.isNotEmpty) {
            return data.first as Map<String, dynamic>;
          }
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
    return {}; // Return an empty map in case of an error or missing data
  }

  Future<void> updateUserDataStatus(int userId, bool newStatus) async {
    try {
      var response = await client
          .from("user")
          .update({"is_active": newStatus}).match({"id": userId}).execute();

      if (response.status == 200 || response.status == 201 || response.status == 204) {
        // Data updated successfully
        // Navigate back to the data pelanggan page
        Get.offNamed(Routes.DATAPELANGGAN);
      } else {
        // Handle the case when the update fails
        print('Failed to update user data');
      }
    } catch (error) {
      // Handle errors
      print('Error updating user data: $error');
    }
  }
}
