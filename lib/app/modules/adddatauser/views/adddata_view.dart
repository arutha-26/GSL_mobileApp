import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/adddata_controller.dart';

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
            popupProps: const PopupProps.menu(
              constraints: BoxConstraints(maxHeight: 170),
              showSelectedItems: true,
            ),
            items: const ["Owner", "Karyawan", "Pelanggan"],
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
                // enabled: false, // Makes the TextField uneditable
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
                child: Text(
                  controller.isLoading.isFalse ? "Tambah Data" : "Loading...",
                ),
              )),
        ],
      ),
    );
  }
}
