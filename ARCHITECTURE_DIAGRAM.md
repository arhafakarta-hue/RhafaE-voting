# DIAGRAM ARSITEKTUR E-PILKETLAS

## 1. ARSITEKTUR APLIKASI SAAT INI

```
┌─────────────────────────────────────────────────────────────┐
│                         MyApp                                │
│                    (MaterialApp)                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     MyHomePage                               │
│                  (StatefulWidget)                            │
│                                                              │
│  State Management: _MyHomePageState                         │
│  ├── _pemilih: List<Pemilih>                               │
│  ├── _kandidat: List<Kandidat>                             │
│  ├── _riwayatVoting: List<RiwayatVoting>                   │
│  ├── _pemilihAktif: Pemilih?                               │
│  ├── _adminAktif: bool                                      │
│  └── Controllers (TextEditingController x 8)                │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
         ▼                               ▼
┌──────────────────┐          ┌──────────────────┐
│  Login/Register  │          │   Admin Panel    │
│      Screen      │          │     Screen       │
└────────┬─────────┘          └────────┬─────────┘
         │                              │
         ▼                              ▼
┌──────────────────┐          ┌──────────────────┐
│  Pemilih Screens │          │  Admin Screens   │
│  ├── Beranda     │          │  ├── Dashboard   │
│  ├── Detail      │          │  ├── Kandidat    │
│  ├── Sukses      │          │  ├── Tambah      │
│  └── Hasil       │          │  ├── Hasil       │
└──────────────────┘          │  └── Riwayat     │
                              └──────────────────┘
```

## 2. FLOW DIAGRAM - PEMILIH

```
     START
       │
       ▼
┌─────────────┐
│   Landing   │
│    Page     │
└──────┬──────┘
       │
       ├─────────────┬─────────────┐
       │             │             │
       ▼             ▼             ▼
   [Login]      [Register]    [Admin]
       │             │             │
       │             ▼             │
       │      ┌──────────────┐    │
       │      │ Validasi:    │    │
       │      │ - Nama ✓     │    │
       │      │ - NIM ✓      │    │
       │      │ - Password ✓ │    │
       │      │ - Duplikasi? │    │
       │      └──────┬───────┘    │
       │             │             │
       └─────────────┴─────────────┘
                     │
                     ▼
            ┌────────────────┐
            │    BERANDA     │
            │                │
            │ - Greeting     │
            │ - Status Vote  │
            │ - List Kandidat│
            └────────┬───────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
    [Lihat      [Vote]      [Logout]
     Detail]        │           │
         │          ▼           ▼
         │   ┌─────────────┐  END
         │   │ Konfirmasi  │
         │   │   Dialog    │
         │   └──────┬──────┘
         │          │
         │      [Yakin?]
         │          │
         │          ▼
         │   ┌─────────────┐
         │   │  Validasi:  │
         │   │ - Sudah     │
         │   │   Memilih?  │
         │   └──────┬──────┘
         │          │
         │          ▼
         │   ┌─────────────┐
         │   │   Update:   │
         │   │ - Suara++   │
         │   │ - Status ✓  │
         │   │ - Riwayat   │
         │   └──────┬──────┘
         │          │
         │          ▼
         │   ┌─────────────┐
         │   │   SUKSES    │
         │   │   PAGE      │
         │   └──────┬──────┘
         │          │
         └──────────┼──────────┐
                    │          │
                    ▼          ▼
              [Lihat      [Logout]
               Hasil]         │
                    │         ▼
                    ▼        END
            ┌─────────────┐
            │ HASIL PAGE  │
            │ Quick Count │
            └─────────────┘
```

## 3. FLOW DIAGRAM - ADMIN

```
     START
       │
       ▼
┌─────────────┐
│   Login     │
│ admin/      │
│ admin123    │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│      ADMIN DASHBOARD                │
│                                     │
│  Bottom Navigation (5 tabs)        │
└──────┬──────────────────────────────┘
       │
       ├──────┬──────┬──────┬──────┐
       │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼
   ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐
   │Home│ │List│ │Add │ │Hasil│ │Log │
   └─┬──┘ └─┬──┘ └─┬──┘ └─┬──┘ └─┬──┘
     │      │      │      │      │
     ▼      ▼      ▼      ▼      ▼
   Stats  View  Create View  View
          All   New    Quick History
          Cand. Cand.  Count
                │
                ▼
         ┌──────────────┐
         │ Form Input:  │
         │ - Foto       │
         │ - Nama       │
         │ - Visi       │
         │ - Misi       │
         └──────┬───────┘
                │
                ▼
         ┌──────────────┐
         │  Validasi:   │
         │ - Required ✓ │
         │ - Duplikasi? │
         └──────┬───────┘
                │
                ▼
         ┌──────────────┐
         │ Save to List │
         │ Navigate to  │
         │ Kandidat Tab │
         └──────────────┘
```

## 4. DATA MODEL DIAGRAM

```
┌─────────────────────────┐
│       Pemilih           │
├─────────────────────────┤
│ - nama: String          │
│ - nim: String           │
│ - password: String      │
│ - sudahMemilih: bool    │
└───────────┬─────────────┘
            │
            │ 1:N (votes)
            │
            ▼
┌─────────────────────────┐
│    RiwayatVoting        │
├─────────────────────────┤
│ - namaPemilih: String   │
│ - nimPemilih: String    │
│ - namaKandidat: String  │
│ - waktu: DateTime       │
└───────────┬─────────────┘
            │
            │ N:1 (for)
            │
            ▼
┌─────────────────────────┐
│       Kandidat          │
├─────────────────────────┤
│ - nama: String          │
│ - visi: String          │
│ - misi: String          │
│ - fotoPath: String?     │
│ - jumlahSuara: int      │
└─────────────────────────┘
```

## 5. WIDGET TREE STRUCTURE

```
MyApp (MaterialApp)
└── MyHomePage (StatefulWidget)
    └── _MyHomePageState
        │
        ├── [Not Logged In]
        │   └── Scaffold
        │       └── SafeArea
        │           └── _buildLoginPage()
        │               └── SingleChildScrollView
        │                   ├── Logo Container
        │                   ├── Title Text
        │                   ├── SegmentedButton (Login/Register)
        │                   └── [Login Form | Register Form]
        │
        ├── [Pemilih Logged In]
        │   └── Scaffold
        │       ├── AppBar
        │       │   ├── Leading (Menu Icon)
        │       │   ├── Title (BERANDA)
        │       │   └── Actions (Logout Button)
        │       └── Body
        │           └── [Beranda | Detail | Sukses | Hasil]
        │
        └── [Admin Logged In]
            └── Scaffold
                ├── AppBar
                │   ├── Title
                │   └── Actions (Logout)
                ├── Body
                │   └── [Dashboard | Kandidat | Tambah | Hasil | Riwayat]
                └── BottomNavigationBar
                    └── 5 NavigationDestination
```

## 6. STATE MANAGEMENT FLOW

```
┌─────────────────────────────────────────────────────────┐
│                    User Action                          │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Event Handler Method                       │
│  (_login, _register, voting, _tambahKandidat, etc.)    │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                   Validation                            │
│  (Check empty fields, duplicates, permissions)          │
└────────────────────────┬────────────────────────────────┘
                         │
                 ┌───────┴───────┐
                 │               │
                 ▼               ▼
            [Invalid]       [Valid]
                 │               │
                 ▼               ▼
         Show SnackBar    ┌─────────────┐
         (Error)          │  setState() │
                          └──────┬──────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   Update State:        │
                    │ - Modify Lists         │
                    │ - Update Flags         │
                    │ - Change Screen        │
                    └────────┬───────────────┘
                             │
                             ▼
                    ┌────────────────────────┐
                    │   Widget Rebuild       │
                    │   (build() called)     │
                    └────────────────────────┘
```

## 7. IMAGE PICKER FLOW

```
User Clicks "Pilih Foto"
         │
         ▼
┌────────────────────┐
│ _pilihFotoKandidat │
│     (async)        │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│  ImagePicker       │
│  .pickImage()      │
│  source: gallery   │
└─────────┬──────────┘
          │
    ┌─────┴─────┐
    │           │
    ▼           ▼
[Cancelled]  [Selected]
    │           │
    │           ▼
    │    ┌──────────────┐
    │    │ Get file path│
    │    └──────┬───────┘
    │           │
    │           ▼
    │    ┌──────────────┐
    │    │  setState()  │
    │    │ _fotoKandidat│
    │    │ Path = path  │
    │    └──────┬───────┘
    │           │
    │           ▼
    │    ┌──────────────┐
    │    │ Show Preview │
    │    │ Image.file() │
    │    └──────────────┘
    │
    └──────────────────────> No change
```

## 8. VOTING PROCESS SEQUENCE

```
Pemilih                 UI                  State               Data
  │                     │                    │                   │
  │  Click [VOTE]       │                    │                   │
  ├────────────────────>│                    │                   │
  │                     │                    │                   │
  │                     │ _konfirmasiVoting()│                   │
  │                     ├───────────────────>│                   │
  │                     │                    │                   │
  │                     │  Check sudahMemilih│                   │
  │                     │<───────────────────┤                   │
  │                     │                    │                   │
  │  Show Dialog        │                    │                   │
  │<────────────────────┤                    │                   │
  │                     │                    │                   │
  │  Click [YAKIN]      │                    │                   │
  ├────────────────────>│                    │                   │
  │                     │                    │                   │
  │                     │    voting()        │                   │
  │                     ├───────────────────>│                   │
  │                     │                    │                   │
  │                     │                    │  kandidat.suara++ │
  │                     │                    ├──────────────────>│
  │                     │                    │                   │
  │                     │                    │  pemilih.sudah=✓  │
  │                     │                    ├──────────────────>│
  │                     │                    │                   │
  │                     │                    │  add riwayat      │
  │                     │                    ├──────────────────>│
  │                     │                    │                   │
  │                     │   setState()       │                   │
  │                     │<───────────────────┤                   │
  │                     │                    │                   │
  │  Navigate to Sukses │                    │                   │
  │<────────────────────┤                    │                   │
  │                     │                    │                   │
```

## 9. ARSITEKTUR YANG DIREKOMENDASIKAN (FUTURE)

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Screens    │  │   Widgets    │  │   Dialogs    │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼──────────────────┼──────────────────┼──────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
┌────────────────────────────┼─────────────────────────────────┐
│                   State Management Layer                     │
│                    (Provider/Riverpod/Bloc)                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ AuthProvider │  │ VoteProvider │  │ AdminProvider│      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼──────────────────┼──────────────────┼──────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
┌────────────────────────────┼─────────────────────────────────┐
│                      Domain Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Use Cases   │  │   Entities   │  │ Repositories │      │
│  │              │  │              │  │  (Interface) │      │
│  └──────────────┘  └──────────────┘  └──────┬───────┘      │
└─────────────────────────────────────────────┼──────────────┘
                                              │
┌─────────────────────────────────────────────┼──────────────┐
│                      Data Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Database   │  │   API Client │  │ Local Storage│     │
│  │   (SQLite)   │  │   (Dio/HTTP) │  │ (SharedPref) │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## 10. FOLDER STRUCTURE YANG DIREKOMENDASIKAN

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   ├── errors/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── voting/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── admin/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── services/
    ├── database_service.dart
    ├── storage_service.dart
    └── image_service.dart
```

---

**Catatan:** Diagram ini menggambarkan arsitektur aplikasi saat ini dan rekomendasi untuk pengembangan lebih lanjut. Implementasi Clean Architecture akan meningkatkan maintainability, testability, dan scalability aplikasi.
