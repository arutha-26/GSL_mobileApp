import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/BuktiTransferClass.dart';
import '../../../utils/PelangganSearchWidget.dart';
import '../controllers/addtransaksi_controller.dart';

class AddtransaksiView extends GetView<AddtransaksiController> {
  AddtransaksiView({super.key});

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
                  PelangganSearchWidget(
                    nameController: controller.nameController,
                    phoneController: controller.phoneController,
                    kategoriController: controller.kategoriController,
                    addtransaksiController: controller,
                    idUserController: controller.idUserController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    enabled: false,
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
                    enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: "No Pelanggan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.kategoriController,
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
                      controller.setSelectedMetode(value);
                      controller.hitungTotalHarga(); // Tambahkan ini
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
                      controller.setSelectedLayanan(value);
                      controller.hitungTotalHarga(); // Tambahkan ini
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
                      FocusScope.of(context)
                          .requestFocus(new FocusNode()); // Prevent keyboard from appearing
                      selectDate(
                          context,
                          controller
                              .tanggalSelesaiController); // Call your date picker function
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: controller.beratLaundryController,
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
                    enabled: false,
                    keyboardType: TextInputType.none,
                    controller: controller.hargaTotalController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Total Harga",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      constraints: BoxConstraints(maxHeight: 120),
                      // 60 are per data height
                      showSelectedItems: true,
                    ),
                    items: const ["Tunai", "Transfer"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Metode Pembayaran",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? value) {
                      controller.setSelectedPembayaran(value);
                      if (kDebugMode) {
                        print(value);
                      }
                      controller.setSelectedPembayaran(value);
                      if (value == "Transfer") {
                        Get.bottomSheet(const BuktiTransfer());
                      } else if (value == "Tunai") {
                        Get.bottomSheet(const Tunai());
                      } else {
                        Get.bottomSheet(const Nope());
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }));
  }
}

class Nope extends StatefulWidget {
  const Nope({Key? key}) : super(key: key);

  @override
  State<Nope> createState() => _Nope();
}

class _Nope extends State<Nope> {
  AddtransaksiController controller = Get.find<AddtransaksiController>();

  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Obx(() => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.addTransaksi();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 40),
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                  ),
                  child: Text(
                    controller.isLoading.isFalse ? "Kirim" : "Loading...",
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class Tunai extends StatefulWidget {
  const Tunai({Key? key}) : super(key: key);

  @override
  State<Tunai> createState() => _Tunai();
}

class _Tunai extends State<Tunai> {
  AddtransaksiController controller = Get.find<AddtransaksiController>();

  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              enabled: false,
              keyboardType: TextInputType.none,
              controller: controller.hargaTotalController,
              decoration: const InputDecoration(
                labelText: "Total Harga",
                border: OutlineInputBorder(),
              ),
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
              enabled: false,
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
            Obx(() => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.addTransaksi();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 40),
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFF22c55e), // Warna teks
                  ),
                  child: Text(
                    controller.isLoading.isFalse ? "Kirim" : "Loading...",
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
