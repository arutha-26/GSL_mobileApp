import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/adddata_controller.dart';

class AdddataView extends GetView<AdddataController> {
  double calculateMaxHeight(String userRole, int itemCount) {
    const itemHeight = 60.0; // Sesuaikan dengan tinggi item dropdown
    const minHeight = 180.0; // Minimal tinggi dropdown jika bukan Karyawan

    // Hitung ketinggian dropdown
    double calculatedHeight =
        userRole == 'Karyawan' ? itemHeight : min(itemCount * itemHeight, minHeight);

    return calculatedHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Pengguna'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading user role'));
          } else {
            return buildForm();
          }
        },
      ),
    );
  }

  Widget buildForm() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        const SizedBox(
          height: 10,
        ),
        TextField(
          autocorrect: false,
          controller: controller.nameC,
          textInputAction: TextInputAction.next,
          onChanged: (String value) {
            controller.emailC.text = "${value.replaceAll(" ", "").toLowerCase()}@gsl.com";
          },
          decoration: const InputDecoration(
            labelText: "Nama Pengguna",
            border: OutlineInputBorder(),
          ),
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
        DropdownSearch<String>(
            popupProps: PopupProps.menu(
              constraints: BoxConstraints(
                maxHeight: calculateMaxHeight(
                    controller.userRole.value, controller.roleOptions.length),
              ),
              showSelectedItems: true,
            ),
            items: controller.userRole.value == 'Karyawan'
                ? const ["Pelanggan"]
                : const ["Owner", "Karyawan", "Pelanggan"],
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (String? value) {
              controller.setSelectedRole(value);
            }),
        const SizedBox(height: 20),
        TextField(
          autocorrect: false,
          controller: controller.nohpC,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14),
          ],
          decoration: const InputDecoration(
            labelText: "No Telp",
            hintText: "819213XXXXXX",
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
          items: const ["-", "Individual", "Hotel", "Villa"],
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
                  controller.addData();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFF22c55e), // Warna teks
              ),
              child: Text(
                controller.isLoading.isFalse ? "Tambah Data" : "Loading...",
              ),
            )),
      ],
    );
  }
}
