import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/adddata_controller.dart';

// TODO
/*
BUG PADA SETELAH CLOSE DATA INPUTAN RANDOM TIDAK MAU HILANG,
SAAT SETELAH INPUT DATA SELESAI TAMBAHKAN FUNC UNTUK KE HALAMAN HOME SESUAI ROLE APAKAH OWNER ATAU KARYAWAN
 */

class AdddataView extends GetView<AdddataController> {
  AdddataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Pengguna'),
        centerTitle: true,
      ),
      body: ListView(
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
              // Automatically update the Email field when the Nama Pengguna field changes
              // You can customize the logic here, this is just an example
              controller.emailC.text = value.replaceAll(" ", "").toLowerCase() + "@gsl.com";
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
            popupProps: const PopupProps.menu(
              constraints: BoxConstraints(maxHeight: 170),
              showSelectedItems: true,
            ),
            items: ["Owner", "Karyawan", "Pelanggan"],
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (String? value) {
              controller.setSelectedRole(value);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.nohpC,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14), // Limit the total length, including "+62"
            ],
            onChanged: (value) {
              // Check if the input is already formatted with "+62"
              if (!value.startsWith("+62")) {
                // Add "+62" at the beginning
                controller.nohpC.value = controller.nohpC.value.copyWith(
                  text: '+62' + value,
                  selection: TextSelection.collapsed(offset: value.length + 3),
                );
              }
            },
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
                    items: ["-","Individual", "Hotel", "Villa"],
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
                controller.signUp();
              }
            },
            child: Text(
              controller.isLoading.isFalse ? "Tambah Data" : "Loading...",
            ),
          )),
        ],
      ),
    );
  }
}