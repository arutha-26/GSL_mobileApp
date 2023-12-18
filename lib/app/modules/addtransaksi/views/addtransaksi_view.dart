import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/PelangganSearchWidget.dart';
import '../controllers/addtransaksi_controller.dart';

class AddtransaksiView extends GetView<AddtransaksiController> {
  AddtransaksiView({Key? key}) : super(key: key);

  final pelangganController = TextEditingController();

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
                    controller: pelangganController,
                    addtransaksiController: controller,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: controller.emailC,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    controller: controller.nohpC,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "No Telp",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    controller: controller.alamatC,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      constraints: BoxConstraints(maxHeight: 170),
                      showSelectedItems: true,
                    ),
                    items: ["-", "Individual", "Hotel", "Villa"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Kategori Pelanggan",
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
                  Obx(() => TextField(
                        autocorrect: false,
                        controller: controller.passwordC,
                        textInputAction: TextInputAction.done,
                        obscureText: controller.isHidden.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => controller.isHidden.toggle(),
                            icon: controller.isHidden.isTrue
                                ? const Icon(Icons.remove_red_eye)
                                : const Icon(Icons.remove_red_eye_outlined),
                          ),
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.addTransaksi();
                          }
                        },
                        child: Text(
                          controller.isLoading.isFalse ? "Tambah Data" : "Loading...",
                        ),
                      )),
                ],
              );
            }));
  }
}
