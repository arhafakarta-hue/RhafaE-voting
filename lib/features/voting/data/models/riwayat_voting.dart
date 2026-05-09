class RiwayatVoting {
  RiwayatVoting({
    required this.namaPemilih,
    required this.nimPemilih,
    required this.namaKandidat,
    required this.waktu,
  });

  final String namaPemilih;
  final String nimPemilih;
  final String namaKandidat;
  final DateTime waktu;

  Map<String, dynamic> toJson() {
    return {
      'namaPemilih': namaPemilih,
      'nimPemilih': nimPemilih,
      'namaKandidat': namaKandidat,
      'waktu': waktu.toIso8601String(),
    };
  }

  factory RiwayatVoting.fromJson(Map<String, dynamic> json) {
    return RiwayatVoting(
      namaPemilih: json['namaPemilih'] as String,
      nimPemilih: json['nimPemilih'] as String,
      namaKandidat: json['namaKandidat'] as String,
      waktu: DateTime.parse(json['waktu'] as String),
    );
  }
}
