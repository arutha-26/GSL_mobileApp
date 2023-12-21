import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/PelangganSearchWidget.dart';
import '../controllers/addtransaksi_controller.dart';

class AddtransaksiView extends GetView<AddtransaksiController> {
  AddtransaksiView({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final kategoriController = TextEditingController();


  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Data Transaksi'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: controller.getDataKaryawan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    enabled: false,
                    autocorrect: false,
                    controller: controller.namaKaryawanC,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Nama Karyawan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PelangganSearchWidget(
                    nameController: nameController,
                    phoneController: phoneController,
                    kategoriController: kategoriController,
                    addtransaksiController: controller,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "No Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: kategoriController,
                    decoration: const InputDecoration(
                      labelText: "Kategori Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      constraints: BoxConstraints(maxHeight: 120),
                      // 60 are per data height
                      showSelectedItems: true,
                    ),
                    items: const ["Regular", "Express"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Metode Laundry",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? value) {
                      controller.setSelectedKategori(value);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      constraints: BoxConstraints(maxHeight: 180),
                      // 60 are per data height
                      showSelectedItems: true,
                    ),
                    items: const ["Cuci Setrika", "Cuci Saja", "Setrika Saja"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Layanan Laundry",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? value) {
                      controller.setSelectedKategori(value);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.tanggalDatangController,
                    decoration: const InputDecoration(
                      labelText: "Tanggal Datang",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode()); // Prevent keyboard from appearing
                      selectDate(context, controller.tanggalDatangController); // Call your date picker function
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.tanggalSelesaiController,
                    decoration: const InputDecoration(
                      labelText: "Tanggal Selesai",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode()); // Prevent keyboard from appearing
                      selectDate(context, controller.tanggalSelesaiController); // Call your date picker function
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.addTransaksi();
                          }
                        },
                        child: Text(
                          controller.isLoading.isFalse ? "Tambah Transaksi" : "Loading...",
                        ),
                      )),
                ],
              );
            }));
  }
}
