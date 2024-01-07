import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/utils/SearchPengambilan.dart';
import 'package:intl/intl.dart';

import '../controllers/pengambilan_laundry_controller.dart';

class PengambilanLaundryView extends GetView<PengambilanLaundryController> {
  PengambilanLaundryView({Key? key}) : super(key: key);

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2105),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Data'),
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
                  SearchPengambilan(
                    idTransaksiController: controller.idTransaksiController,
                    nameController: controller.nameController,
                    phoneController: controller.phoneController,
                    beratController: controller.beratController,
                    totalHargaController: controller.totalHargaController,
                    metodePembayaranController: controller.metodePembayaranController,
                    statusPembayaranControlller: controller.statusPembayaranController,
                    statusCucianController: controller.statusCucianController,
                    pengambilanLaundryController: controller,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.none,
                    controller: controller.idTransaksiController,
                    decoration: const InputDecoration(
                      labelText: "Id Transaksi",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.none,
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.none,
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: "Nomor Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: controller.beratController,
                    // controller diubah
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Berat Laundry",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.totalHargaController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Total Harga",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.metodePembayaranController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Metode Pembayaran",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.statusPembayaranController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Status Pembayaran",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.statusCucianController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Status Cucian",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Update Data Dibawah ini!'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.tanggalDiambilController,
                    decoration: const InputDecoration(
                      labelText: "Tanggal Diambil",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      FocusScope.of(context)
                          .requestFocus(new FocusNode()); // Prevent keyboard from appearing
                      selectDate(
                          context,
                          controller
                              .tanggalDiambilController); // Call your date picker function
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      constraints: BoxConstraints(maxHeight: 180),
                      // 60 are per data height
                      showSelectedItems: true,
                    ),
                    items: const ["-", "Tunai", "Transfer"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Metode Pembayaran",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? value) {
                      controller.setSelectedPembayaran(value);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Opsi "Sudah Dibayar"
                      Obx(() => GestureDetector(
                            onTap: () => controller.setStatusPembayaran('sudah_dibayar'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.statusPembayaran.value == 'sudah_dibayar'
                                    ? Colors.green[100]
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.statusPembayaran.value == 'sudah_dibayar'
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.payment, color: Colors.green),
                                  Text('Sudah Dibayar'),
                                ],
                              ),
                            ),
                          )),

                      // Opsi "Belum Dibayar"
                      Obx(() => GestureDetector(
                            onTap: () => controller.setStatusPembayaran('belum_dibayar'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.statusPembayaran.value == 'belum_dibayar'
                                    ? Colors.red[100]
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.statusPembayaran.value == 'belum_dibayar'
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.payment, color: Colors.red),
                                  Text('Belum Dibayar'),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Opsi "Diproses"
                      Obx(() => GestureDetector(
                            onTap: () => controller.setStatusCucian('diproses'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.statusCucian.value == 'diproses'
                                    ? Colors.blue[100]
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.statusCucian.value == 'diproses'
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.hourglass_empty, color: Colors.blue),
                                  Text('Diproses'),
                                ],
                              ),
                            ),
                          )),

                      // Opsi "Selesai"
                      Obx(() => GestureDetector(
                            onTap: () => controller.setStatusCucian('selesai'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.statusCucian.value == 'selesai'
                                    ? Colors.green[100]
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.statusCucian.value == 'selesai'
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.check_circle_outline, color: Colors.green),
                                  Text('Selesai'),
                                ],
                              ),
                            ),
                          )),
                      // Opsi "Diambil"
                      Obx(() => GestureDetector(
                            onTap: () => controller.setStatusCucian('diambil'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.statusCucian.value == 'diambil'
                                    ? Colors.orange[100]
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.statusCucian.value == 'diambil'
                                      ? Colors.orange
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.done_all, color: Colors.orange),
                                  Text('Diambil'),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.updateTransaksi();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFF22c55e), // Warna teks
                        ),
                        child: Text(
                          controller.isLoading.isFalse ? "Kirim" : "Loading...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                ],
              );
            }));
  }
}
