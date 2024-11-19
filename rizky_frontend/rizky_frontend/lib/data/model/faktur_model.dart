import 'dart:convert';

class FakturModel {
  final String? kode;
  final String description;
  final String price;
  final String stock;

  FakturModel({
    this.kode,
    required this.description,
    required this.price,
    required this.stock,
  });

  factory FakturModel.fromRawJson(String str) =>
      FakturModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FakturModel.fromJson(Map<String, dynamic> json) => FakturModel(
        kode: json["kode"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "kode": kode,
        "description": description,
        "price": price,
        "stock": stock,
      };
}
