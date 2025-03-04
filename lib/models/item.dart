import 'dart:io';

class Item {
  final int? id;
  final String nama;
  final String kategori;
  final int? jumlah;
  final String deskripsi;
  final String? imageUrl;
  final File? image;
  final String status;

  Item({
    this.id,
    required this.nama,
    required this.kategori,
    required this.jumlah,
    required this.deskripsi,
    this.imageUrl,
    this.image,
    required this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      jumlah: json['jumlah'],
      deskripsi: json['deskripsi'],
      imageUrl: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'jumlah': jumlah,
      'deskripsi': deskripsi,
      'image': image?.path,
      'status': status,
    };
  }
}

