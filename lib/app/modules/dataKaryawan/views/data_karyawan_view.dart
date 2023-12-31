import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/data_karyawan_controller.dart';

class DataKaryawanView extends GetView<DataKaryawanController> {
  DataKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Karyawan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: TextField(
              onChanged: (value) {
                // Trigger search based on the entered value
                controller.searchByName(value);
              },
              decoration: InputDecoration(
                labelText: 'Cari Data Berdasarkan Nama',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: controller.fetchData(), // Use the fetchData method as the future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while loading data
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Handle errors
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Data has been loaded successfully
                  return Obx(() {
                    return ListView.builder(
                      itemCount: controller.filteredData.length,
                      itemBuilder: (context, index) {
                        var userData = controller.filteredData[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Card(
                            color: userData['is_active'] == true
                                ? Colors.greenAccent
                                : Colors.red[700],
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              title: Row(
                                children: [
                                  Image.asset(
                                    (userData['name'] == 'pakeh')
                                        ? 'images/pake_h.png'
                                        : (userData['role'] == 'Owner')
                                            ? 'images/owner_profile.png'
                                            : (userData['role'] == 'Karyawan')
                                                ? 'images/karyawan_profile.png'
                                                : 'images/user_profile.png',
                                    // Provide a default photo path if none of the conditions match
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nama: ${userData['nama']}',
                                          style: TextStyle(
                                            color: userData['is_active'] == true
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: userData['is_active'] == true
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Role: ${userData['role']}',
                                          style: TextStyle(
                                            color: userData['is_active'] == true
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: userData['is_active'] == true
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_KARYAWAN, arguments: userData);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
