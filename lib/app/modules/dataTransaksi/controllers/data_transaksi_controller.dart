import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;

  Rx<DateTime> startDate = Rx(DateTime.now());
  Rx<DateTime> endDate = Rx(DateTime.now());
  RxInt totalDataCount = 0.obs; // Variable to store the total data count

  Future<void> fetchDataWithDateRange({int page = 1}) async {
    try {
      isLoading.value = true;

      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', '${startDate.value.toLocal()}')
          .lte('tanggal_datang', '${endDate.value.toLocal().add(const Duration(days: 1))}')
          .order('tanggal_datang', ascending: true)
          .execute();

      if (response != null && response.data is List) {
        data.value = (response.data as List)
            .map<Map<String, dynamic>>((item) {
              final editAt = DateTime.parse(item['tanggal_datang'] as String);
              final formattedDate = '${editAt.day}-${editAt.month}-${editAt.year}';
              final berat = (item['berat_laundry'] as num);
              final formattedBerat = '$berat Kg';
              final harga = (item['total_biaya'] as num);
              NumberFormat currencyFormatter =
                  NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
              final formatHarga = currencyFormatter.format(harga);

              final nomor = (item['nomor_pelanggan'] as String);
              final formattedNomor = '+62$nomor';
              final cucian = (item['status_cucian'] as String);
              final formattedCucian = cucian.capitalizeFirst;
              final statusPembayaran = item['status_pembayaran'] as String;
              final formattedStatusP =
                  statusPembayaran == 'sudah_dibayar' ? 'Sudah Dibayar' : 'Belum Dibayar';

              return {
                'transaksi_id': item['transaksi_id'],
                'nama_pelanggan': item['nama_pelanggan'],
                'total_biaya': formatHarga,
                'tanggal_datang': formattedDate,
              };
            })
            .where((item) => item.isNotEmpty)
            .toList();

        totalDataCount.value = data.length;

        final List<Map<String, dynamic>> newData = [];

        final itemsPerPage = 10;
        final startIdx = (page - 1) * itemsPerPage;

        if (startIdx < data.length) {
          for (var index = 0;
              index < itemsPerPage && (startIdx + index) < data.length;
              index++) {
            final item = data[startIdx + index];
            newData.add({
              ...item,
              'nomor_urut': startIdx + index + 1,
            });
          }
          data.value = newData;
        } else {
          data.value = [];
        }

        if (kDebugMode) {
          print('Fetched data: $data');
        }
      } else {
        if (kDebugMode) {
          print('Error: Invalid data format');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }

  final Map<String, String> columnNames = {
    'transaksi_id': 'ID',
    'nama_pelanggan': 'Nama Pelanggan',
    'nomor_pelanggan': 'Nomor Pelanggan',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'nama_karyawan_masuk': 'Nama Karyawan Penerima',
    'metode_laundry': 'Metode Laundry',
    'layanan_laundry': 'Layanan Laundry',
    'berat_laundry': 'Berat Laundry',
    'total_biaya': 'Total Biaya',
    'metode_pembayaran': 'Metode Pembayaran',
    'status_pembayaran': 'Status Pembayaran',
    'tanggal_datang': 'Tanggal Datang',
    'tanggal_selesai': 'Tanggal Selesai',
    'status_cucian': 'Status Cucian',
    'is_hidden': 'Is Hidden',
    'edit_at': 'Edit At'
  };
}
