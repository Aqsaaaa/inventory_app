class History {
  final int? id;
  final int idBarang;
  final String status;
  final String deskripsiPemakaian;
  final String createdAt;

  History({
    this.id,
    required this.idBarang,
    required this.status,
    required this.deskripsiPemakaian,
    required this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      idBarang: json['id_barang'],
      status: json['status'],
      deskripsiPemakaian: json['deskripsi_pemakaian'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_barang': idBarang,
      'status': status,
      'deskripsi_pemakaian': deskripsiPemakaian,
      'created_at': createdAt,
    };
  }
}
