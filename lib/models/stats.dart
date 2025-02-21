class Stats {
  final int dipakai;
  final int dikembalikan;
  final int rusak;
  final int tersedia;
 

  Stats({
    required this.dipakai,
    required this.dikembalikan,
    required this.rusak,
    required this.tersedia,

  });

  factory Stats.fromJson(Map<int, dynamic> json) {
    return Stats(
      dipakai: json['dipakai'],
      dikembalikan: json['dikembalikan'],
      rusak: json['rusak'],
      tersedia: json['tersedia'],
    );
  }
}
