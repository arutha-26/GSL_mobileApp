import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import package http atau package lain yang Anda gunakan

class DetailpelangganController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  Future<Map<String, dynamic>> getdatapelanggan(Map<String, dynamic> userData) async {
    try {
      var response = await client
          .from("user")
          .select()
          .match({"id": userData['id']}) // Gunakan kunci yang sesuai dari userData
          .execute();

      if (response.status == 200 && response.data != null) {
        List<dynamic> data = response.data as List<dynamic>;
        if (data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
    return {};
  }
}
