# Update Foto Kandidat - Selesai

## ✅ Perubahan yang Telah Dilakukan

### 1. Foto Ditambahkan ke Assets
Dua foto kandidat telah ditambahkan ke folder `assets/images/`:
- `a77ef5e8-062c-4b63-9dcb-ad70373a7621.jpg` - Foto untuk Andea Farhan Pratama
- `f17abec1-8344-47e6-bbc3-79fa5cc130c8.jpg` - Foto untuk Cepriyanto

### 2. VotingProvider Diupdate
File: `lib/features/voting/presentation/providers/voting_provider.dart`

Kedua kandidat sekarang memiliki foto path:
```dart
Kandidat(
  nama: 'Andea Farhan Pratama',
  visi: 'Menjadikan kelas lebih kompak, disiplin, dan aktif dalam kegiatan kampus serta organisasi.',
  misi: '1. Membuat jadwal piket yang adil dan teratur.\n2. Menampung aspirasi teman-teman kelas.\n3. Mengadakan evaluasi kelas setiap bulan.\n4. Meningkatkan komunikasi antar mahasiswa.',
  fotoPath: 'assets/images/a77ef5e8-062c-4b63-9dcb-ad70373a7621.jpg',
),
Kandidat(
  nama: 'Cepriyanto',
  visi: 'Mewujudkan kelas yang solid, peduli, dan berprestasi dalam akademik maupun non-akademik.',
  misi: '1. Menguatkan kerja sama antar mahasiswa.\n2. Membantu teman yang kesulitan dalam perkuliahan.\n3. Menjaga komunikasi dengan dosen wali.\n4. Mengadakan kegiatan kelas yang bermanfaat.',
  fotoPath: 'assets/images/f17abec1-8344-47e6-bbc3-79fa5cc130c8.jpg',
),
```

### 3. KandidatPhotoWidget Diupdate
File: `lib/core/widgets/kandidat_photo_widget.dart`

Widget sekarang mendukung asset images dengan menambahkan pengecekan:
```dart
// Cek apakah asset image
if (path.startsWith('assets/')) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildAvatar(),
    ),
  );
}
```

## 🚀 Cara Menjalankan Aplikasi

### Opsi 1: Windows
```bash
cd "c:\Flutter Project\rpl_project"
flutter run -d windows
```

### Opsi 2: Android Emulator
```bash
cd "c:\Flutter Project\rpl_project"
flutter run
```

### Opsi 3: Chrome (Web)
```bash
cd "c:\Flutter Project\rpl_project"
flutter run -d chrome
```

## 📸 Dimana Foto Akan Muncul

Foto kandidat akan muncul di:
1. **Halaman Voting** - Saat pemilih melihat daftar kandidat
2. **Halaman Admin - Daftar Kandidat** - Saat admin melihat semua kandidat
3. **Halaman Hasil Voting** - Saat melihat hasil pemilihan

## ✅ Checklist Testing

Setelah menjalankan aplikasi, pastikan:
- [ ] Aplikasi berhasil dijalankan tanpa error
- [ ] Login sebagai pemilih (contoh: nim: 2301010001, password: password123)
- [ ] Foto Andea Farhan Pratama muncul di halaman voting
- [ ] Foto Cepriyanto muncul di halaman voting
- [ ] Login sebagai admin (username: admin, password: admin123)
- [ ] Foto kedua kandidat muncul di tab "Daftar"
- [ ] Foto muncul dengan baik (tidak pecah/blur)

## 🐛 Troubleshooting

### Jika foto tidak muncul:
1. Pastikan `flutter pub get` sudah dijalankan
2. Restart aplikasi (stop dan run ulang)
3. Cek console untuk error messages
4. Pastikan file foto ada di `assets/images/`

### Jika ada error build:
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Catatan

- Foto disimpan sebagai asset, bukan file dinamis
- Foto akan di-bundle dengan aplikasi
- Untuk menambah kandidat baru dengan foto, gunakan fitur "Tambah Kandidat" di admin panel
- Foto yang ditambah melalui admin akan disimpan di storage lokal, bukan di assets
