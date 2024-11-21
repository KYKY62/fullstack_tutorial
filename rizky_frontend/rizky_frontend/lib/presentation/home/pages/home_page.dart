import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizky_frontend/presentation/home/controller/home_controller.dart';
import 'package:rizky_frontend/presentation/home/pages/add_page.dart';
import 'package:rizky_frontend/presentation/home/pages/edit_page.dart';

class HomePage extends StatelessWidget {
  final homeC = Get.put(HomeController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: homeC.searchController,
            focusNode: homeC.focusNode,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () {
                    homeC.focusNode.unfocus();
                    homeC.searchByKode(homeC.searchController.text);
                  },
                  child: const Icon(Icons.search_outlined)),
              hintText: 'Cari Kode',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            textInputAction: TextInputAction.search,
            // agar keyboard search langsung mencari
            onFieldSubmitted: (value) => homeC.searchByKode(value),
          ),
          actions: const [
            Icon(
              Icons.sort,
              size: 24.0,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => AddPage()),
          child: const Icon(
            Icons.add,
            size: 24.0,
          ),
        ),
        body: Obx(() {
          if (homeC.isLoading.value == true) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeC.fakturList.isEmpty) {
            return const Center(
              child: Text("Tidak ada data"),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: homeC.fakturFilterList.length == 1
                ? homeC.fakturFilterList.length
                : homeC.fakturList.length,
            itemBuilder: (context, index) {
              final faktur = homeC.fakturFilterList.length == 1
                  ? homeC.fakturFilterList[index]
                  : homeC.fakturList[index];
              return GestureDetector(
                onTap: () {
                  homeC.kodeController.text = faktur.kode!;
                  homeC.descController.text = faktur.description;
                  homeC.priceController.text = faktur.price;
                  homeC.stockController.text = faktur.stock;

                  Get.to(() => EditPage());
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(faktur.kode!),
                        Text(faktur.description),
                        Text('Harga : ${faktur.price}'),
                        Text(
                          faktur.stock == '0'
                              ? 'Stock Kosong'
                              : 'Stock : ${faktur.stock}',
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => homeC.deleteFaktur(faktur.kode!),
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }));
  }
}
