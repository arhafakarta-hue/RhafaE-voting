import '../../features/auth/presentation/providers/auth_provider.dart';

class DummyUsers {
  static final List<Map<String, String>> users = [
    // Data dummy untuk testing
    {
      'nama': 'Ahmad Fauzi',
      'nim': '2021001',
      'password': 'fauzi123',
    },
    {
      'nama': 'Siti Nurhaliza',
      'nim': '2021002',
      'password': 'siti123',
    },
    {
      'nama': 'Budi Santoso',
      'nim': '2021003',
      'password': 'budi123',
    },
    {
      'nama': 'Dewi Lestari',
      'nim': '2021004',
      'password': 'dewi123',
    },
    {
      'nama': 'Eko Prasetyo',
      'nim': '2021005',
      'password': 'eko123',
    },
    // Data teman kelas
    {
      'nama': 'Cesty Novica Dwi Putri',
      'nim': '2024230001',
      'password': '2024230001',
    },
    {
      'nama': 'Rhado Fahrel Nassution',
      'nim': '2024230003',
      'password': '2024230003',
    },
    {
      'nama': 'Cepriyanto',
      'nim': '2024230004',
      'password': '2024230004',
    },
    {
      'nama': 'Nayla Puspita Sari',
      'nim': '2024230005',
      'password': '2024230005',
    },
    {
      'nama': 'Zaharani Putri',
      'nim': '2024230007',
      'password': '2024230007',
    },
    {
      'nama': 'Muhammad Saputra',
      'nim': '2024230009',
      'password': '2024230009',
    },
    {
      'nama': 'Fitriani',
      'nim': '2024230010',
      'password': '2024230010',
    },
    {
      'nama': 'Andea Farhan Pratama',
      'nim': '2024230011',
      'password': '2024230011',
    },
    {
      'nama': 'Intan Purnama',
      'nim': '2024230012',
      'password': '2024230012',
    },
    {
      'nama': 'Dini Aprilianti',
      'nim': '2024230014',
      'password': '2024230014',
    },
    {
      'nama': 'Monica Syahrianti',
      'nim': '2024230015',
      'password': '2024230015',
    },
    {
      'nama': 'Tri Agustin',
      'nim': '2024230016',
      'password': '2024230016',
    },
    {
      'nama': 'Nelshen Zariko Apral',
      'nim': '2024230017',
      'password': '2024230017',
    },
    {
      'nama': 'Piki Saputra',
      'nim': '2024230018',
      'password': '2024230018',
    },
    {
      'nama': 'Verlin Patimah',
      'nim': '2024230019',
      'password': '2024230019',
    },
    {
      'nama': 'Anthera Akbar Valentino',
      'nim': '2024230020',
      'password': '2024230020',
    },
    {
      'nama': 'Dimas Fitrian Saputra',
      'nim': '2024230021',
      'password': '2024230021',
    },
    {
      'nama': 'Rhafa Karta Wijaya',
      'nim': '2024230045',
      'password': '2024230045',
    },
  ];

  static void registerDummyUsers(AuthProvider authProvider) {
    for (var user in users) {
      // Check if user already exists
      final exists = authProvider.pemilih.any((p) => p.nim == user['nim']);
      if (!exists) {
        authProvider.register(
          user['nama']!,
          user['nim']!,
          user['password']!,
        );
        authProvider.logout(); // Logout after each registration
      }
    }
  }
}
