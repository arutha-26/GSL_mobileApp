import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/datapelanggan_controller.dart';

class DatapelangganView extends GetView<DatapelangganController> {
  DatapelangganView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Pelanggan'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (controller.data.isEmpty) {
            print('No data available.');
            return const Center(
              child: Text('No data available.'),
            );
          }

          print('Fetched data: ${controller.data}');

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width, // Adjust the width as needed
              child: DataTable2(
                columns: [
                  const DataColumn2(
                    label: Text('No.'),
                    size: ColumnSize.S,
                  ),
                  for (var key in controller.data[0].keys)
                    if (key != 'id') // Exclude the 'id' column
                      DataColumn2(
                        label: Text(key.capitalizeFirst.toString()),
                        size: ColumnSize.L,
                      ),
                ],
                rows: [
                  for (int i = 0; i < controller.data.length; i++)
                    DataRow(
                      cells: [
                        DataCell(Text('${i + 1}')),
                        for (var key in controller.data[i].keys)
                          if (key != 'id') // Exclude the 'id' column
                            DataCell(
                              Text('${controller.data[i][key]}'),
                              onTap: () {
                                // Tambahkan aksi yang sesuai saat baris ditekan di sini
                                // Misalnya, navigasi ke halaman lain
                                Get.toNamed(Routes.DETAILPELANGGAN, arguments: controller.data[i]); // Ganti '/detail_page' dengan rute halaman detail Anda
                              },
                            ),
                      ],
                    ),
                ],
              ),
            ),
          );

        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation using Get
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.OWNERHOME); // Replace '/home' with your actual home route
              break;
            case 1:
              Get.offAllNamed('/dashboard'); // Replace '/dashboard' with your actual dashboard route
              break;
            case 2:
              Get.offAllNamed(Routes.OWNERPROFILE); // Replace '/profile' with your actual profile route
              break;
            default:
          }
        },
      ),
    );
  }
}
