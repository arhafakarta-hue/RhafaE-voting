# 🗳️ E-PILKETLAS - Aplikasi Pemilihan Ketua Kelas

Aplikasi pemilihan ketua kelas berbasis Flutter dengan fitur lengkap dan modern.

## 📱 Fitur Utama

### Untuk Pemilih (Siswa)
- ✅ Login dengan NIS/NIM
- ✅ Dashboard dengan statistik real-time
- ✅ Lihat daftar kandidat dengan foto
- ✅ Lihat detail visi & misi kandidat
- ✅ Vote untuk kandidat pilihan (1x voting)
- ✅ Lihat hasil quick count
- ✅ History pemilihan terbaru
- ✅ Profil user dengan status voting

### Untuk Admin
- ✅ Login sebagai admin
- ✅ Dashboard statistik lengkap
- ✅ Tambah kandidat dengan foto
- ✅ Lihat daftar semua kandidat
- ✅ Lihat hasil voting real-time
- ✅ Lihat riwayat voting lengkap
- ✅ Foto tersimpan permanen

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd "c:\Flutter Project\rpl_project"
flutter pub get
```

### 2. Run Aplikasi

```bash
flutter run
```

## 🔐 Login Credentials

### Admin
- **Username:** `admin`
- **Password:** `admin123`

### Teman Kelas (18 users sudah terdaftar)

| Nama | NIS/NIM | Password |
|------|---------|----------|
| Cesty Novica Dwi Putri | 2024230001 | 2024230001 |
| Rhado Fahrel Nassution | 2024230003 | 2024230003 |
| Cepriyanto | 2024230004 | 2024230004 |
| Nayla Puspita Sari | 2024230005 | 2024230005 |
| Zaharani Putri | 2024230007 | 2024230007 |
| Muhammad Saputra | 2024230009 | 2024230009 |
| Fitriani | 2024230010 | 2024230010 |
| Andea Farhan Pratama | 2024230011 | 2024230011 |
| Intan Purnama | 2024230012 | 2024230012 |
| Dini Aprilianti | 2024230014 | 2024230014 |
| Monica Syahrianti | 2024230015 | 2024230015 |
| Tri Agustin | 2024230016 | 2024230016 |
| Nelshen Zariko Apral | 2024230017 | 2024230017 |
| Piki Saputra | 2024230018 | 2024230018 |
| Verlin Patimah | 2024230019 | 2024230019 |
| Anthera Akbar Valentino | 2024230020 | 2024230020 |
| Dimas Fitrian Saputra | 2024230021 | 2024230021 |
| Rhafa Karta Wijaya | 2024230045 | 2024230045 |

**Catatan:** Password = NIS/NIM yang sama

### Testing Users (5 users)

| Nama | NIS/NIM | Password |
|------|---------|----------|
| Ahmad Fauzi | 2021001 | fauzi123 |
| Siti Nurhaliza | 2021002 | siti123 |
| Budi Santoso | 2021003 | budi123 |
| Dewi Lestari | 2021004 | dewi123 |
| Eko Prasetyo | 2021005 | eko123 |

## 📖 Cara Menggunakan

### Sebagai Pemilih

1. **Login**
   - Masukkan NIS/NIM (contoh: 2024230001)
   - Masukkan Password (sama dengan NIS/NIM)
   - Tap "LOGIN"

2. **Dashboard**
   - Lihat statistik total suara dan kandidat
   - Lihat history pemilihan terbaru
   - Tap icon profil (pojok kanan atas) untuk lihat detail

3. **Voting**
   - Scroll ke "Daftar Kandidat"
   - Tap "Lihat Detail" untuk melihat visi & misi
   - Tap "VOTE" untuk memilih kandidat
   - Konfirmasi pilihan
   - Selesai! Anda sudah memilih

4. **Navigasi**
   - Tap icon menu (☰) untuk membuka drawer
   - Pilih menu: Beranda, Kandidat, Hasil, atau Logout

### Sebagai Admin

1. **Login**
   - Username: `admin`
   - Password: `admin123`

2. **Dashboard**
   - Lihat statistik: Kandidat, Pemilih, Total Suara

3. **Tambah Kandidat**
   - Tap menu "Tambah" di bottom navigation
   - Tap "Pilih Foto" untuk memilih foto dari galeri
   - Isi Nama Kandidat
   - Isi Visi Kandidat
   - Isi Misi Kandidat
   - Tap "Tambah Kandidat"
   - Foto akan tersimpan permanen!

4. **Lihat Hasil**
   - Tap menu "Hasil" untuk melihat quick count
   - Lihat pemenang sementara
   - Lihat jumlah suara per kandidat

5. **Lihat Riwayat**
   - Tap menu "Riwayat" untuk melihat history voting
   - Lihat siapa memilih siapa dengan timestamp

## 🏗️ Arsitektur

```
lib/
├── main.dart                 # Entry point
├── core/                     # Shared resources
│   ├── constants/           # App constants & dummy users
│   ├── utils/               # Helper functions
│   └── widgets/             # Reusable widgets
├── features/                # Feature modules
│   ├── auth/                # Authentication
│   ├── voting/              # Voting system
│   └── admin/               # Admin panel
└── services/                # Services
    └── image_storage_service.dart
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  image_picker: ^1.1.2      # Untuk pilih foto
  provider: ^6.1.2          # State management
  path_provider: ^2.1.1     # Akses folder aplikasi
  path: ^1.8.3              # Manipulasi path
```

## 📁 Penyimpanan Foto

Foto kandidat disimpan di folder permanen:

- **Android:** `/data/data/com.example.rpl_project/files/kandidat_photos/`
- **iOS:** `Documents/kandidat_photos/`
- **Windows:** `AppData/Local/rpl_project/kandidat_photos/`

## 🐛 Troubleshooting

### Masalah: Dummy users tidak bisa login

**Solusi:**
1. Restart aplikasi
2. Users akan otomatis terdaftar saat aplikasi start
3. Coba login dengan credentials di atas

### Masalah: Tidak bisa menambah foto

**Solusi:**
1. Jalankan `flutter pub get`
2. Restart aplikasi
3. Pastikan permissions sudah ada di AndroidManifest.xml
4. Lihat file `PANDUAN_FOTO.md` untuk detail lengkap

### Masalah: Error saat build

**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Dokumentasi Lengkap

- [ANALISIS_PERKEMBANGAN.md](ANALISIS_PERKEMBANGAN.md) - Analisis detail aplikasi
- [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md) - Diagram arsitektur
- [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Summary refactoring
- [REFACTORING_COMPLETE.md](REFACTORING_COMPLETE.md) - Hasil refactoring
- [DUMMY_USERS.md](DUMMY_USERS.md) - Daftar lengkap dummy users
- [PANDUAN_FOTO.md](PANDUAN_FOTO.md) - Panduan mengatasi masalah foto

## 🎨 Screenshots

### Login Screen
- Logo sekolah
- Form login/register
- Hint untuk admin login

### Dashboard Pemilih
- Card sambutan dengan gradient
- Statistik total suara & kandidat
- Daftar kandidat dengan foto
- History pemilihan terbaru

### Dashboard Admin
- Statistik lengkap
- Daftar kandidat
- Form tambah kandidat dengan foto
- Hasil voting real-time
- Riwayat voting lengkap

## 🔧 Development

### Run in Debug Mode
```bash
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
```

### Build iOS
```bash
flutter build ios --release
```

## 📊 Statistik Proyek

- **Total Files:** 25+ files
- **Lines of Code:** ~3,000+ lines
- **Features:** 15+ fitur
- **Users Registered:** 23 users
- **Platforms:** Android, iOS, Web, Windows, Linux, macOS

## 👥 Tim Pengembang

- **Development:** Tim RPL
- **Refactoring:** Kiro AI Assistant
- **Version:** 2.0.0
- **Last Updated:** 10 Mei 2026

## 📄 License

Project ini untuk keperluan edukasi (RPL - Rekayasa Perangkat Lunak).

## 🆘 Support

Jika ada masalah atau pertanyaan:
1. Baca dokumentasi di folder project
2. Cek file PANDUAN_FOTO.md untuk masalah foto
3. Cek file DUMMY_USERS.md untuk daftar user

---

**Version:** 2.0.0  
**Status:** ✅ Production Ready (Development)  
**Date:** 10 Mei 2026

🎉 **Selamat menggunakan E-PILKETLAS!**
