import 'package:get/get.dart';
import 'package:gsl/app/data/models/karyawan_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerhomeController extends GetxController {

  static const supabaseUrl = 'https://vegdoanlxklpbvutmiij.supabase.co';
  static const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTU0NjkyOSwiZXhwIjoxOTQ1MTIyOTI5fQ.9HQP76mHV-JrCo9KH3I-HeM27kGk-yK1UZYddPtWzp0';
  final supabase_client = SupabaseClient(supabaseUrl, supabaseKey);
  RxList allKaryawan = List<Karyawan>.empty().obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> getAllKaryawan() async {
    List<dynamic> res = await client
        .from("karyawan")
        .select("karyawan_id")
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    int id = user["karyawan_id"]; //get user id before get all notes data
    var karyawan = await client.from("karyawan").select().match(
      {"karyawan_id": id}, //get all notes data with match user id
    );
    List<Karyawan> karyawanData = Karyawan.fromJsonList((karyawan as List));
    allKaryawan(karyawanData);
    allKaryawan.refresh();
  }

  Future<void> deleteKaryawan(int id) async {
    await client.from("notes").delete().match({
      "id": id,
    });
    getAllKaryawan();
  }
}
