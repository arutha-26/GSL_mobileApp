import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailDataTransaksiController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxBool isLoading = false.obs;

  Future<String> fetchEmployeeName(int employeeId) async {
    try {
      var userResponse =
          await client.from("user").select('nama').match({"id_user": employeeId}).execute();

      return userResponse.data.isNotEmpty ? userResponse.data.first['nama'].toString() : '';
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
      return ''; // Return an empty string in case of failure
    }
  }

  Future<Map<String, dynamic>> getDataTransaksi(Map<String, dynamic> dataPanel) async {
    try {
      var response = await client
          .from("transaksi")
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, metode_pembayaran, kembalian, nominal_bayar, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .match({"id_transaksi": dataPanel['id_transaksi']}).execute();

      if (response.status == 200 && response.data != null && response.data.isNotEmpty) {
        var transaksiData = response.data.first;

        // Fetch the employee names separately using the id_karyawan_masuk and id_karyawan_keluar
        var idMasuk = transaksiData['id_karyawan_masuk'];
        var idKeluar = transaksiData['id_karyawan_keluar'];

        if (idMasuk != null && idMasuk is int) {
          transaksiData['id_karyawan_masuk'] = await fetchEmployeeName(idMasuk);
        }

        if (idKeluar != null && idKeluar is int) {
          transaksiData['id_karyawan_keluar'] = await fetchEmployeeName(idKeluar);
        }

        return transaksiData;
      } else {
        if (kDebugMode) {
          print('No data found or bad response: ${response.toString()}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    }
    return {}; // Return an empty map in case of failure
  }
}
