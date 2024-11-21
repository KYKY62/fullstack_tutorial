import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizky_frontend/core/constant/api_faktur.dart';
import 'package:rizky_frontend/data/model/faktur_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('OnInit berhasil');
    getFaktur();
  }

  final TextEditingController searchController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  var getAllFakturOrFilter = Rx<Future<List<FakturModel>>?>(null);
  final FocusNode focusNode =
      FocusNode(); // untuk menghilangkan cursor saat keyboard ditutup
  var fakturList = <FakturModel>[].obs;
  var fakturFilterList = <FakturModel>[].obs;
  var isLoading = false.obs;

  void clearController() {
    kodeController.clear();
    descController.clear();
    priceController.clear();
    stockController.clear();
  }

  Future<void> getFaktur() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${ApiFaktur.baseUrl}/get.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List getFakturs = json.decode(response.body)['data'];
        // mengisi ke Rx fakturList
        fakturList.value =
            getFakturs.map((data) => FakturModel.fromJson(data)).toList();
      } else {
        throw Exception();
      }
    } catch (_) {
      fakturList.clear();
      fakturFilterList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchByKode(String kode) {
    if (kode.isEmpty) {
      // Jika input kosong, kosongkan filter
      fakturFilterList.value = [];
    }

    // Filter data berdasarkan kode
    final hasilPencarian = fakturList
        .where(
          (faktur) => faktur.kode!.toLowerCase() == kode.toLowerCase(),
        )
        .toList();

    if (hasilPencarian.isNotEmpty) {
      // Ambil hanya data pertama
      fakturFilterList.value = [hasilPencarian.first];
    } else {
      // kosongkan fakturfilterList
      fakturFilterList.value = [];
      Get.snackbar("Pencarian", "Kode tidak ditemukan");
    }
  }

  void editFaktur() async {
    try {
      Uri url = Uri.parse('${ApiFaktur.baseUrl}/update.php');
      FakturModel fakturModel = FakturModel(
        kode: kodeController.text,
        description: descController.text,
        price: priceController.text,
        stock: stockController.text,
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: fakturModel.toRawJson(),
      );

      // mencari index fakturList
      final index = fakturList.indexWhere(
        (faktur) =>
            faktur.kode!.toLowerCase() == kodeController.text.toLowerCase(),
      );

      if (index == -1) {
        throw Exception();
      }

      if (response.statusCode == 200) {
        // perbarui fakturList sesuai index dengan data fakturModel
        fakturList[index] = fakturModel;
        clearController();
        Get.back();
      } else {
        print("gagal");
      }
    } catch (_) {
      print('Gagal');
    }
  }

  void deleteFaktur(String kode) async {
    try {
      Uri url = Uri.parse('${ApiFaktur.baseUrl}/delete.php?kode=$kode');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // menghapus isi dari fakturList berdasarkan kode
        fakturList.removeWhere(
          (faktur) => faktur.kode!.toLowerCase() == kode.toLowerCase(),
        );
        Get.snackbar(
          'Informasi',
          'Faktur Telah Dihapus',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (_) {}
  }

  void addFaktur() async {
    try {
      Uri url = Uri.parse('${ApiFaktur.baseUrl}/create.php');
      FakturModel fakturModel = FakturModel(
        kode: kodeController.text,
        description: descController.text,
        price: priceController.text,
        stock: stockController.text,
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: fakturModel.toRawJson(),
      );
      if (response.statusCode == 200) {
        Get.back();
        clearController();
        fakturList.add(fakturModel);
        Get.snackbar(
          'Informasi',
          'Faktur Telah Dibuat',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
