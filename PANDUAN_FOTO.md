# PANDUAN MENGATASI MASALAH FOTO

## 🔧 Langkah-langkah Perbaikan

### 1. Install Dependencies

Jalankan command berikut di terminal:

```bash
cd "c:\Flutter Project\rpl_project"
flutter pub get
```

### 2. Restart Aplikasi

Setelah `flutter pub get` selesai, restart aplikasi:

```bash
flutter run
```

### 3. Permissions (Android)

Pastikan permissions sudah ditambahkan di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

### 4. Permissions (iOS)

Pastikan permissions sudah ditambahkan di `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses ke galeri untuk memilih foto kandidat</string>
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses ke kamera untuk mengambil foto kandidat</string>
```

## 📸 Cara Menambah Foto Kandidat

### Sebagai Admin:

1. **Login sebagai admin**
   - Username: `admin`
   - Password: `admin123`

2. **Buka menu "Tambah"** di bottom navigation

3. **Tap "Pilih Foto"**
   - Akan membuka galeri
   - Pilih foto kandidat

4. **Preview foto** akan muncul

5. **Isi data kandidat:**
   - Nama Kandidat
   - Visi Kandidat
   - Misi Kandidat

6. **Tap "Tambah Kandidat"**
   - Loading akan muncul
   - Foto akan disimpan ke folder permanen
   - Kandidat berhasil ditambahkan!

## 🐛 Troubleshooting

### Masalah: Foto tidak bisa dipilih

**Solusi:**
1. Pastikan sudah `flutter pub get`
2. Restart aplikasi
3. Cek permissions di AndroidManifest.xml atau Info.plist
4. Coba uninstall dan install ulang aplikasi

### Masalah: Foto tidak muncul setelah ditambahkan

**Solusi:**
1. Cek apakah foto tersimpan di folder `kandidat_photos`
2. Restart aplikasi
3. Cek log error di console

### Masalah: Error "path_provider not found"

**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📁 Lokasi Penyimpanan Foto

- **Android**: `/data/data/com.example.rpl_project/files/kandidat_photos/`
- **iOS**: `Documents/kandidat_photos/`
- **Windows**: `AppData/Local/rpl_project/kandidat_photos/`

## ✅ Checklist

- [ ] `flutter pub get` sudah dijalankan
- [ ] Aplikasi sudah direstart
- [ ] Permissions sudah ditambahkan
- [ ] Login sebagai admin berhasil
- [ ] Bisa membuka galeri
- [ ] Foto bisa dipilih dan preview muncul
- [ ] Kandidat berhasil ditambahkan dengan foto

## 🆘 Jika Masih Bermasalah

Jalankan command berikut untuk debug:

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run with verbose
flutter run -v
```

Lihat error message di console dan share jika masih ada masalah.
