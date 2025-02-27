class Item {
  final int? id;
  final String nama;
  final String kategori;
  late final int? jumlah;
  final String deskripsi;
  final String? image;
  final String status;

  Item({
    this.id,
    required this.nama,
    required this.kategori,
    required this.jumlah,
    required this.deskripsi,
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
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'kategori': kategori,
      'jumlah': jumlah,
      'deskripsi': deskripsi,
      'image': image,
      'status': status,
    };
  }
}
