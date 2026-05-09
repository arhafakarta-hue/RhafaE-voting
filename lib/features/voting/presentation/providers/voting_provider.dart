import 'package:flutter/material.dart';
import '../../data/models/kandidat.dart';
import '../../data/models/riwayat_voting.dart';
import '../../../auth/data/models/pemilih.dart';

class VotingProvider extends ChangeNotifier {
  final List<Kandidat> _kandidat = [
    Kandidat(
      nama: 'Andea Farhan Pratama',
      visi:
          'Menjadikan kelas lebih kompak, disiplin, dan aktif dalam kegiatan kampus serta organisasi.',
      misi:
          '1. Membuat jadwal piket yang adil dan teratur.\n2. Menampung aspirasi teman-teman kelas.\n3. Mengadakan evaluasi kelas setiap bulan.\n4. Meningkatkan komunikasi antar mahasiswa.',
      fotoPath: 'images/a77ef5e8-062c-4b63-9dcb-ad70373a7621.jpg',
    ),
    Kandidat(
      nama: 'Cepriyanto',
      visi: 'Mewujudkan kelas yang solid, peduli, dan berprestasi dalam akademik maupun non-akademik.',
      misi:
          '1. Menguatkan kerja sama antar mahasiswa.\n2. Membantu teman yang kesulitan dalam perkuliahan.\n3. Menjaga komunikasi dengan dosen wali.\n4. Mengadakan kegiatan kelas yang bermanfaat.',
      fotoPath: 'images/f17abec1-8344-47e6-bbc3-79fa5cc130c8.jpg',
    ),
  ];

  final List<RiwayatVoting> _riwayatVoting = [];

  List<Kandidat> get kandidat => List.unmodifiable(_kandidat);
  List<RiwayatVoting> get riwayatVoting => List.unmodifiable(_riwayatVoting);

  int get totalSuara =>
      _kandidat.fold(0, (total, kandidat) => total + kandidat.jumlahSuara);

  List<Kandidat> getHasilVoting() {
    final hasil = List<Kandidat>.from(_kandidat);
    hasil.sort((a, b) => b.jumlahSuara.compareTo(a.jumlahSuara));
    return hasil;
  }

  Kandidat? getPemenang() {
    final hasil = getHasilVoting();
    if (hasil.isNotEmpty && hasil.first.jumlahSuara > 0) {
      return hasil.first;
    }
    return null;
  }

  bool tambahKandidat(String nama, String visi, String misi, String? fotoPath) {
    if (nama.isEmpty || visi.isEmpty || misi.isEmpty) {
      return false;
    }

    if (_kandidat.any(
      (k) => k.nama.toLowerCase() == nama.toLowerCase(),
    )) {
      return false;
    }

    _kandidat.add(
      Kandidat(
        nama: nama,
        visi: visi,
        misi: misi,
        fotoPath: fotoPath,
      ),
    );
    notifyListeners();
    return true;
  }

  bool vote(Pemilih pemilih, Kandidat kandidat) {
    if (pemilih.sudahMemilih) {
      return false;
    }

    kandidat.jumlahSuara++;
    pemilih.sudahMemilih = true;

    _riwayatVoting.insert(
      0,
      RiwayatVoting(
        namaPemilih: pemilih.nama,
        nimPemilih: pemilih.nim,
        namaKandidat: kandidat.nama,
        waktu: DateTime.now(),
      ),
    );

    notifyListeners();
    return true;
  }
}
