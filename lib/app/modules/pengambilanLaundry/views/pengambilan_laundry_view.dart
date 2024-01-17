import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
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

  Widget _buildInfoRow(String labelText, TextEditingController controller) {
    return Row(
      children: [
        Text(
          labelText,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            textAlign: TextAlign.end,
            controller.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
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
                  SearchPengambilan(
                    idTransaksiController: controller.idTransaksiController,
                    idUserController: controller.idUserController,
                    beratController: controller.beratController,
                    totalHargaController: controller.totalHargaController,
                    metodePembayaranController: controller.metodePembayaranController,
                    statusPembayaranControlller: controller.statusPembayaranController,
                    statusCucianController: controller.statusCucianController,
                    pengambilanLaundryController: controller,
                    namaController: controller.namaController,
                    noTelpController: controller.noTelpController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    // elevation: 0, // Sesuaikan elevasi sesuai kebutuhan
                    margin: const EdgeInsets.all(10), // Tambahkan margin sesuai kebutuhan
                    color: Colors.white, // Atur latar belakang kartu menjadi putih
                    shape: RoundedRectangleBorder(
                      // Menambahkan border hitam dengan ketebalan 1
                      side: const BorderSide(color: Colors.black, width: 1),
                      borderRadius:
                          BorderRadius.circular(8), // Sesuaikan radius border sesuai kebutuhan
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildInfoRow("Nama Pelanggan", controller.namaController),
                          const SizedBox(height: 20),
                          _buildInfoRow("Nomor Pelanggan", controller.noTelpController),
                          const SizedBox(height: 20),
                          _buildInfoRow("Berat Laundry", controller.beratController),
                          const SizedBox(height: 20),
                          _buildInfoRow("Total Harga", controller.totalHargaController),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                              "Metode Pembayaran", controller.metodePembayaranController),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                              "Status Pembayaran", controller.statusPembayaranController),
                          const SizedBox(height: 20),
                          _buildInfoRow("Status Cucian", controller.statusCucianController),
                        ],
                      ),
                    ),
                  ),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Button Tapped!");
                          }
                          if (controller.isUpdateDataLoading.isFalse) {
                            controller.updateDateFieldVisibility();
                            controller.update();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFF22c55e), // Warna teks
                        ),
                        child: Text(
                          controller.isUpdateDataLoading.isFalse
                              ? "Update Data"
                              : "Loading...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                  Obx(
                    () => Visibility(
                      visible: controller.isDateFieldVisible.value,
                      child: Column(
                        children: [
                          // const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          const Text('Update Data Dibawah ini!'),
                          if (controller.statusCucianController.text.toString() ==
                                  'Diproses' &&
                              controller.statusPembayaranController.text.toString() ==
                                  "Belum Dibayar") ...[
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
                                            Icon(Icons.check_circle_outline,
                                                color: Colors.green),
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
                                    if (controller.isKirimLoading.isFalse) {
                                      controller.updateTransaksi();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(400, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                                  ),
                                  child: Text(
                                    controller.isKirimLoading.isFalse ? "Kirim" : "Loading...",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )),
                          ] else if (controller.statusCucianController.text.toString() ==
                                  'Diproses' &&
                              controller.statusPembayaranController.text.toString() ==
                                  "Sudah Dibayar") ...[
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
                                            Icon(Icons.check_circle_outline,
                                                color: Colors.green),
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
                                    if (controller.isKirimLoading.isFalse) {
                                      controller.updateTransaksi();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(400, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                                  ),
                                  child: Text(
                                    controller.isKirimLoading.isFalse ? "Kirim" : "Loading...",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )),
                          ] else if (controller.statusCucianController.text.toString() ==
                                  'Selesai' &&
                              controller.statusPembayaranController.text.toString() ==
                                  "Belum Dibayar") ...[
                            TextField(
                              controller: controller.tanggalDiambilController,
                              decoration: const InputDecoration(
                                labelText: "Tanggal Diambil",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () {
                                FocusScope.of(context).requestFocus(
                                    new FocusNode()); // Prevent keyboard from appearing
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
                            const SizedBox(height: 20),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: controller.nominalBayarController,
                              decoration: const InputDecoration(
                                labelText: "Nominal Bayar",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              keyboardType: TextInputType.none,
                              controller: controller.kembalianController,
                              decoration: const InputDecoration(
                                labelText: "Kembalian",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Opsi "Sudah Dibayar"
                                Obx(() => GestureDetector(
                                      onTap: () =>
                                          controller.setStatusPembayaran('sudah_dibayar'),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: controller.statusPembayaran.value ==
                                                  'sudah_dibayar'
                                              ? Colors.green[100]
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: controller.statusPembayaran.value ==
                                                    'sudah_dibayar'
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
                                      onTap: () =>
                                          controller.setStatusPembayaran('belum_dibayar'),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: controller.statusPembayaran.value ==
                                                  'belum_dibayar'
                                              ? Colors.red[100]
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: controller.statusPembayaran.value ==
                                                    'belum_dibayar'
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
                                            Icon(Icons.check_circle_outline,
                                                color: Colors.green),
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
                                    if (controller.isKirimLoading.isFalse) {
                                      controller.updateTransaksi();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(400, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                                  ),
                                  child: Text(
                                    controller.isKirimLoading.isFalse ? "Kirim" : "Loading...",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )),
                          ] else if (controller.statusCucianController.text.toString() ==
                                  'Selesai' &&
                              controller.statusPembayaranController.text.toString() ==
                                  "Sudah Dibayar") ...[
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
                                            Icon(Icons.check_circle_outline,
                                                color: Colors.green),
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
                                FocusScope.of(context).requestFocus(
                                    new FocusNode()); // Prevent keyboard from appearing
                                selectDate(
                                    context,
                                    controller
                                        .tanggalDiambilController); // Call your date picker function
                              },
                            ),
                            const SizedBox(height: 20),
                            Obx(() => ElevatedButton(
                                  onPressed: () {
                                    if (controller.isKirimLoading.isFalse) {
                                      controller.updateTransaksi();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(400, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                                  ),
                                  child: Text(
                                    controller.isKirimLoading.isFalse ? "Kirim" : "Loading...",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
