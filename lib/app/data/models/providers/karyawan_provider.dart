import 'package:get/get.dart';

import '../karyawan_model.dart';

class KaryawanProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Karyawan.fromJson(map);
      if (map is List)
        return map.map((item) => Karyawan.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Karyawan?> getKaryawan(int id) async {
    final response = await get('karyawan/$id');
    return response.body;
  }

  Future<Response<Karyawan>> postKaryawan(Karyawan karyawan) async =>
      await post('karyawan', karyawan);
  Future<Response> deleteKaryawan(int id) async => await delete('karyawan/$id');
}
