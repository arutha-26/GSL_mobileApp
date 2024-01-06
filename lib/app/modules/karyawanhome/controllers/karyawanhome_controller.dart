import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KaryawanhomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  Future<String?> getUserRole() async {
    try {
      // Assuming 'uid' matches the 'id' in the Supabase auth table
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        if (kDebugMode) {
          print("User ID not found");
        }
        return null;
      }

      var response = await client
          .from('user') // Replace with your user details table name
          .select('role')
          .eq('uid', uid)
          .single()
          .execute();

      if (response.data != null && response.data.isNotEmpty) {
        return response.data['role'] as String?;
      } else {
        if (kDebugMode) {
          print("No user found");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
      return null;
    }
  }

  final count = 0.obs;

  @override
  void onInit() {
    getUserRole();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
