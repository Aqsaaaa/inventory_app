class History {
  final int? id;
  final int idBarang;
  final String namaBarang;
  final String status;
  final String namaPeminjam;
  final int jumlahYangDipinjam;
  final String alasan;
  final DateTime? createdAt;

  History({
    this.id,
    required this.idBarang,
    required this.namaBarang,
    required this.status,
    required this.namaPeminjam,
    required this.jumlahYangDipinjam,
    required this.alasan,
    this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      idBarang: json['id_barang'],
      namaBarang: json['nama_barang'],
      status: json['status'],
      namaPeminjam: json['nama_peminjam'],
      jumlahYangDipinjam: json['jumlah_yang_dipinjam'],
      alasan: json['alasan'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_barang': idBarang,
      'nama_barang': namaBarang,
      'status': status,
      'nama_peminjam': namaPeminjam,
      'jumlah_yang_dipinjam': jumlahYangDipinjam,
      'alasan': alasan,
    };
  }
}
