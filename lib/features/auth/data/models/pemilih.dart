class Pemilih {
  Pemilih({
    required this.nama,
    required this.nim,
    required this.password,
    this.sudahMemilih = false,
  });

  final String nama;
  final String nim;
  final String password;
  bool sudahMemilih;

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'password': password,
      'sudahMemilih': sudahMemilih,
    };
  }

  factory Pemilih.fromJson(Map<String, dynamic> json) {
    return Pemilih(
      nama: json['nama'] as String,
      nim: json['nim'] as String,
      password: json['password'] as String,
      sudahMemilih: json['sudahMemilih'] as bool? ?? false,
    );
  }

  Pemilih copyWith({
    String? nama,
    String? nim,
    String? password,
    bool? sudahMemilih,
  }) {
    return Pemilih(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      password: password ?? this.password,
      sudahMemilih: sudahMemilih ?? this.sudahMemilih,
    );
  }
}
