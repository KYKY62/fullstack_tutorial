import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizky_frontend/core/component/textformfield_component.dart';
import 'package:rizky_frontend/presentation/home/controller/home_controller.dart';

class EditPage extends StatelessWidget {
  final homeC = Get.put(HomeController());
  EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Page"),
        actions: const [],
      ),
      body: Column(
        children: [
          // TextformfieldComponent(
          //   controller: homeC.kodeController,
          //   hintText: 'Kode',
          // ),
          TextformfieldComponent(
            controller: homeC.descController,
            hintText: 'Deskripsi',
          ),
          TextformfieldComponent(
            controller: homeC.priceController,
            hintText: 'Price',
          ),
          TextformfieldComponent(
            controller: homeC.stockController,
            hintText: 'Stock',
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            width: Get.width,
            child: ElevatedButton(
              onPressed: () => homeC.editFaktur(),
              child: const Text('Simpan Perubahan'),
            ),
          )
        ],
      ),
    );
  }
}
