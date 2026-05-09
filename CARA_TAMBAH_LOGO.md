# CARA MENAMBAHKAN LOGO UNPRA

## 📋 Langkah-langkah

### 1. Simpan Logo
- Nama file: `logo_unpra.png`
- Format: PNG (dengan background transparan lebih bagus)
- Ukuran: Minimal 120x120 px (bisa lebih besar)

### 2. Letakkan di Folder
```
c:\Flutter Project\rpl_project\
└── assets\
    └── images\
        └── logo_unpra.png  ← Simpan di sini!
```

### 3. Jalankan Command
```bash
cd "c:\Flutter Project\rpl_project"
flutter pub get
```

### 4. Restart Aplikasi
```bash
flutter run
```

## ✅ Hasil

Logo UNPRA akan muncul di:
- ✅ Form Login (ukuran 120x120)
- ✅ Form Register (ukuran 120x120)
- ✅ Dengan fallback jika logo tidak ditemukan

## 🎨 Tips

- Gunakan PNG dengan background transparan
- Ukuran optimal: 256x256 px atau 512x512 px
- File size: Usahakan < 100 KB

## 🐛 Troubleshooting

**Jika logo tidak muncul:**
1. Pastikan nama file: `logo_unpra.png` (huruf kecil semua)
2. Pastikan lokasi: `assets/images/logo_unpra.png`
3. Jalankan: `flutter clean && flutter pub get`
4. Restart aplikasi

**Jika masih tidak muncul:**
- Logo placeholder (icon sekolah) akan muncul sebagai fallback
- Cek console untuk error message
