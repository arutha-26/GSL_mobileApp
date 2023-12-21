import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gsl/app/modules/detailpaneltransaksi/controllers/detailpaneltransaksi_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/paneltransaksi_controller.dart';

class PaneltransaksiView extends GetView<PaneltransaksiController> {
  PaneltransaksiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Transaksi'),
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
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (controller.data.isEmpty) {
            return const Center(
              child: Text('No data available.'),
            );
          }

          // Define the columns using the columnNames mapping
          List<DataColumn> columns = controller.data[0].keys.map((key) {
            return DataColumn(
              label: Text(controller.columnNames[key] ?? key.capitalizeFirst!),
            );
          }).toList();

          // Define the rows based on the data
          List<DataRow> rows = controller.data.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, dynamic> row = entry.value;

            return DataRow(
              cells: row.keys.map((key) {
                return DataCell(
                  Text('${row[key]}'),
                  onTap: () {
                    if (controller.data[idx] != null) {
                      print('Navigating to: ${Routes.DETAILPANELTRANSAKSI}, with data: ${controller.data[idx]}');
                      Get.toNamed(Routes.DETAILPANELTRANSAKSI, arguments: controller.data[idx]);
                    } else {
                      print('Error: Data for index $idx is null');
                    }
                  },
                );
              }).toList(),
            );
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns,
                rows: rows,
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
