class Kandidat {
  Kandidat({
    required this.nama,
    required this.visi,
    required this.misi,
    this.fotoPath,
    this.jumlahSuara = 0,
  });

  final String nama;
  final String visi;
  final String misi;
  final String? fotoPath;
  int jumlahSuara;

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'visi': visi,
      'misi': misi,
      'fotoPath': fotoPath,
      'jumlahSuara': jumlahSuara,
    };
  }

  factory Kandidat.fromJson(Map<String, dynamic> json) {
    return Kandidat(
      nama: json['nama'] as String,
      visi: json['visi'] as String,
      misi: json['misi'] as String,
      fotoPath: json['fotoPath'] as String?,
      jumlahSuara: json['jumlahSuara'] as int? ?? 0,
    );
  }

  Kandidat copyWith({
    String? nama,
    String? visi,
    String? misi,
    String? fotoPath,
    int? jumlahSuara,
  }) {
    return Kandidat(
      nama: nama ?? this.nama,
      visi: visi ?? this.visi,
      misi: misi ?? this.misi,
      fotoPath: fotoPath ?? this.fotoPath,
      jumlahSuara: jumlahSuara ?? this.jumlahSuara,
    );
  }
}
