import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailpaneltransaksiController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  Future<Map<String, dynamic>> getDataPanelTransaksi(Map<String, dynamic> dataPanel) async {
    try {
      var response = await client
          .from("harga")
          .select()
          .match({"id": dataPanel['id']})
          .execute();

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
}
