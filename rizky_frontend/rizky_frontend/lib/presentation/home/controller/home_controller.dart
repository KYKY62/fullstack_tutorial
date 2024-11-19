import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizky_frontend/core/constant/api_faktur.dart';
import 'package:rizky_frontend/data/model/faktur_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  var getAllFakturOrFilter = Rx<Future<List<FakturModel>>?>(null);
  final FocusNode focusNode =
      FocusNode(); // untuk menghilangkan cursor saat keyboard ditutup

  void clearController() {
    kodeController.clear();
    descController.clear();
    priceController.clear();
    stockController.clear();
  }

  Future<List<FakturModel>> getFaktur() async {
    try {
      Uri url = Uri.parse('${ApiFaktur.baseUrl}/get.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List getFakturs = json.decode(response.body)['data'];
        return getFakturs.map((data) => FakturModel.fromJson(data)).toList();
      } else {
        throw Exception();
      }
    } catch (_) {
      return [];
    }
  }

  Future<List<FakturModel>> filterKode() async {
    try {
      Uri url = Uri.parse(
          '${ApiFaktur.baseUrl}/get.php?kode=${searchController.text}');
      final response = await http.get(url);
      List getFakturs = json.decode(response.body);
      //  karna return filter kode salah nya maka dibuat if agar dapat
      // menampilkan pesan data kosong dan return balik ke getFaktur
      if (response.statusCode == 200 && getFakturs[0]['success'] == true) {
        return getFakturs.map((data) => FakturModel.fromJson(data)).toList();
      } else {
        Get.snackbar(
          'Kode Gagal Dicari',
          'Kode Tidak Ada',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
        );

        return getFaktur();
      }
    } catch (_) {
      return [];
    }
  }

  void searchByKode() => getAllFakturOrFilter.value = filterKode();

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
      if (response.statusCode == 200) {
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
        print(response.body);
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
