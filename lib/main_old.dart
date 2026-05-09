import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

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
}

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
}

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
}

enum PemilihScreen { beranda, detail, sukses, hasil }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-PILKETLAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Pemilih> _pemilih = [];
  final List<Kandidat> _kandidat = [
    Kandidat(
      nama: 'Budi Santoso',
      visi:
          'Menjadikan kelas lebih kompak, disiplin, dan aktif dalam kegiatan sekolah.',
      misi:
          '1. Membuat jadwal piket yang adil.\n2. Menampung aspirasi teman-teman.\n3. Mengadakan evaluasi kelas setiap minggu.',
    ),
    Kandidat(
      nama: 'Siti Aminah',
      visi: 'Mewujudkan kelas yang tertib, peduli, dan berprestasi.',
      misi:
          '1. Menguatkan kerja sama antar siswa.\n2. Membantu teman yang kesulitan belajar.\n3. Menjaga komunikasi dengan wali kelas.',
    ),
    Kandidat(
      nama: 'Andi Wijaya',
      visi:
          'Membangun suasana kelas yang nyaman, kreatif, dan bertanggung jawab.',
      misi:
          '1. Mengadakan program kebersihan kelas.\n2. Membuat agenda belajar kelompok.\n3. Mengajak kelas aktif mengikuti lomba.',
    ),
  ];
  final List<RiwayatVoting> _riwayatVoting = [];

  final _namaRegisterController = TextEditingController();
  final _nimRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _nimLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();
  final _kandidatController = TextEditingController();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _sedangLogin = true;
  bool _adminAktif = false;
  int _halamanAdmin = 0;
  PemilihScreen _layarPemilih = PemilihScreen.beranda;
  Pemilih? _pemilihAktif;
  Kandidat? _kandidatDetail;
  String? _fotoKandidatPath;

  @override
  void dispose() {
    _namaRegisterController.dispose();
    _nimRegisterController.dispose();
    _passwordRegisterController.dispose();
    _nimLoginController.dispose();
    _passwordLoginController.dispose();
    _kandidatController.dispose();
    _visiController.dispose();
    _misiController.dispose();
    super.dispose();
  }

  void _register() {
    final nama = _namaRegisterController.text.trim();
    final nim = _nimRegisterController.text.trim();
    final password = _passwordRegisterController.text.trim();

    if (nama.isEmpty || nim.isEmpty || password.isEmpty) {
      _tampilkanPesan('Nama, NIS/NIM, dan token wajib diisi.');
      return;
    }

    if (_pemilih.any((pemilih) => pemilih.nim == nim)) {
      _tampilkanPesan('NIS/NIM sudah terdaftar.');
      return;
    }

    final akun = Pemilih(nama: nama, nim: nim, password: password);
    setState(() {
      _pemilih.add(akun);
      _pemilihAktif = akun;
      _adminAktif = false;
      _layarPemilih = PemilihScreen.beranda;
      _namaRegisterController.clear();
      _nimRegisterController.clear();
      _passwordRegisterController.clear();
    });
  }

  void _login() {
    final nim = _nimLoginController.text.trim();
    final password = _passwordLoginController.text.trim();

    if (nim.isEmpty || password.isEmpty) {
      _tampilkanPesan('NIS/NIM atau token wajib diisi.');
      return;
    }

    if (nim.toLowerCase() == 'admin' && password == 'admin123') {
      setState(() {
        _adminAktif = true;
        _pemilihAktif = null;
        _halamanAdmin = 0;
        _nimLoginController.clear();
        _passwordLoginController.clear();
      });
      return;
    }

    for (final pemilih in _pemilih) {
      if (pemilih.nim == nim && pemilih.password == password) {
        setState(() {
          _pemilihAktif = pemilih;
          _adminAktif = false;
          _layarPemilih = PemilihScreen.beranda;
          _nimLoginController.clear();
          _passwordLoginController.clear();
        });
        return;
      }
    }

    _tampilkanPesan('NIS/NIM atau token salah.');
  }

  void _logout() {
    setState(() {
      _pemilihAktif = null;
      _adminAktif = false;
      _kandidatDetail = null;
      _fotoKandidatPath = null;
      _layarPemilih = PemilihScreen.beranda;
      _halamanAdmin = 0;
      _sedangLogin = true;
    });
  }

  Future<void> _pilihFotoKandidat() async {
    final foto = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (foto == null) return;
    setState(() => _fotoKandidatPath = foto.path);
  }

  void _tambahKandidat() {
    final nama = _kandidatController.text.trim();
    final visi = _visiController.text.trim();
    final misi = _misiController.text.trim();

    if (!_adminAktif) return;
    if (nama.isEmpty || visi.isEmpty || misi.isEmpty) {
      _tampilkanPesan('Nama, visi, dan misi kandidat wajib diisi.');
      return;
    }
    if (_kandidat.any(
      (kandidat) => kandidat.nama.toLowerCase() == nama.toLowerCase(),
    )) {
      _tampilkanPesan('Nama kandidat sudah terdaftar.');
      return;
    }

    setState(() {
      _kandidat.add(
        Kandidat(
          nama: nama,
          visi: visi,
          misi: misi,
          fotoPath: _fotoKandidatPath,
        ),
      );
      _kandidatController.clear();
      _visiController.clear();
      _misiController.clear();
      _fotoKandidatPath = null;
      _halamanAdmin = 1;
    });
  }

  void voting(Pemilih pemilih, Kandidat kandidat) {
    if (pemilih.sudahMemilih) {
      _tampilkanPesan('Hak suara kamu sudah digunakan.');
      return;
    }

    setState(() {
      kandidat.jumlahSuara++;
      pemilih.sudahMemilih = true;
      _kandidatDetail = null;
      _layarPemilih = PemilihScreen.sukses;
      _riwayatVoting.insert(
        0,
        RiwayatVoting(
          namaPemilih: pemilih.nama,
          nimPemilih: pemilih.nim,
          namaKandidat: kandidat.nama,
          waktu: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _konfirmasiVoting(Kandidat kandidat) async {
    final pemilih = _pemilihAktif;
    if (pemilih == null) return;
    if (pemilih.sudahMemilih) {
      _tampilkanPesan('Pilihan yang sudah dikirim tidak dapat diubah lagi.');
      return;
    }

    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'KONFIRMASI',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin memberikan suara untuk:\n\n"${kandidat.nama.toUpperCase()}"\n\nPilihan yang sudah dikirim tidak dapat diubah lagi.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('BATAL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('YAKIN'),
          ),
        ],
      ),
    );

    if (yakin == true) voting(pemilih, kandidat);
  }

  List<Kandidat> hitungHasil() {
    final hasil = List<Kandidat>.from(_kandidat);
    hasil.sort((a, b) => b.jumlahSuara.compareTo(a.jumlahSuara));
    return hasil;
  }

  int get _totalSuara =>
      _kandidat.fold(0, (total, kandidat) => total + kandidat.jumlahSuara);

  String _formatWaktu(DateTime waktu) {
    final jam = waktu.hour.toString().padLeft(2, '0');
    final menit = waktu.minute.toString().padLeft(2, '0');
    return '$jam:$menit';
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    if (_adminAktif) return _buildAdminScaffold();
    if (_pemilihAktif != null) return _buildPemilihScaffold(_pemilihAktif!);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildLoginPage()),
    );
  }

  Widget _buildLoginPage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  color: Colors.grey.shade100,
                ),
                alignment: Alignment.center,
                child: const Text('Logo\nSekolah', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'E-PILKETLAS',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
            ),
            const Text(
              'Pemilihan Ketua Kelas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 36),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Login')),
                ButtonSegment(value: false, label: Text('Register')),
              ],
              selected: {_sedangLogin},
              onSelectionChanged: (value) =>
                  setState(() => _sedangLogin = value.first),
            ),
            const SizedBox(height: 18),
            if (_sedangLogin) _buildLoginForm() else _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('NIS / NIM', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          key: const Key('login_nim'),
          controller: _nimLoginController,
          decoration: const InputDecoration(
            hintText: 'Masukkan NIS/NIM',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Password / Token',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('login_password'),
          controller: _passwordLoginController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '********',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _login(),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _login, child: const Text('LOGIN')),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('register_nama'),
          controller: _namaRegisterController,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('register_nim'),
          controller: _nimRegisterController,
          decoration: const InputDecoration(
            labelText: 'NIS / NIM',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('register_password'),
          controller: _passwordRegisterController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password / Token',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _register(),
        ),
        const SizedBox(height: 18),
        FilledButton(onPressed: _register, child: const Text('REGISTER')),
      ],
    );
  }

  Widget _buildPemilihScaffold(Pemilih pemilih) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _layarPemilih == PemilihScreen.detail
          ? AppBar(
              leading: BackButton(
                onPressed: () =>
                    setState(() => _layarPemilih = PemilihScreen.beranda),
              ),
              title: const Text('PROFIL KANDIDAT'),
            )
          : AppBar(
              leading: const Icon(Icons.menu),
              title: const Text(
                'BERANDA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.account_circle_outlined),
                  tooltip: 'Logout',
                ),
              ],
            ),
      body: SafeArea(child: _buildPemilihBody(pemilih)),
    );
  }

  Widget _buildPemilihBody(Pemilih pemilih) {
    return switch (_layarPemilih) {
      PemilihScreen.beranda => _buildBerandaPemilih(pemilih),
      PemilihScreen.detail => _buildDetailKandidat(
        _kandidatDetail ?? _kandidat.first,
      ),
      PemilihScreen.sukses => _buildSuksesPage(),
      PemilihScreen.hasil => _buildHasilPage(showBackToSuccess: true),
    };
  }

  Widget _buildBerandaPemilih(Pemilih pemilih) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hai, ${pemilih.nama}!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Status Hak Suara: [ ${pemilih.sudahMemilih ? 'SUDAH MEMILIH' : 'BELUM MEMILIH'} ]',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'DAFTAR KANDIDAT KETUA KELAS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < _kandidat.length; i++)
          _buildKandidatVoteCard(_kandidat[i], i + 1, pemilih),
      ],
    );
  }

  Widget _buildKandidatVoteCard(Kandidat kandidat, int nomor, Pemilih pemilih) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black26),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _buildKandidatPhoto(kandidat, 86),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$nomor. ${kandidat.nama}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => setState(() {
                      _kandidatDetail = kandidat;
                      _layarPemilih = PemilihScreen.detail;
                    }),
                    child: const Text('[ Lihat Visi & Misi ]'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: pemilih.sudahMemilih
                          ? null
                          : () => _konfirmasiVoting(kandidat),
                      child: Text('[VOTE # $nomor]'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailKandidat(Kandidat kandidat) {
    final nomor = _kandidat.indexOf(kandidat) + 1;
    final pemilih = _pemilihAktif!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(child: _buildKandidatPhoto(kandidat, 160)),
        const SizedBox(height: 18),
        Text(
          'Kandidat No. $nomor',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        Text(
          kandidat.nama,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 24),
        const Text(
          'VISI',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        Text(kandidat.visi, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        const Text(
          'MISI',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        Text(kandidat.misi, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () =>
                    setState(() => _layarPemilih = PemilihScreen.beranda),
                child: const Text('[KEMBALI]'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: pemilih.sudahMemilih
                    ? null
                    : () => _konfirmasiVoting(kandidat),
                child: const Text('[VOTE]'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuksesPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 110,
              color: Colors.grey,
            ),
            const SizedBox(height: 28),
            const Text(
              'TERIMA KASIH!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              'Suara kamu berhasil direkam.\nHak suara kamu telah digunakan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () =>
                  setState(() => _layarPemilih = PemilihScreen.hasil),
              child: const Text('LIHAT HASIL (Quick Count)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _logout, child: const Text('[LOGOUT]')),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilPage({bool showBackToSuccess = false}) {
    final hasil = hitungHasil();
    final pemenang = hasil.isNotEmpty && hasil.first.jumlahSuara > 0
        ? hasil.first
        : null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (showBackToSuccess)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _layarPemilih = PemilihScreen.sukses),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ),
        const Text(
          'HASIL QUICK COUNT',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text('Total suara masuk: $_totalSuara'),
        if (pemenang != null)
          Text(
            'Pemenang sementara: ${pemenang.nama}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 12),
        for (final kandidat in hasil)
          ListTile(
            leading: _buildKandidatPhoto(kandidat, 48),
            title: Text(kandidat.nama),
            trailing: Text('${kandidat.jumlahSuara} suara'),
          ),
      ],
    );
  }

  Widget _buildAdminScaffold() {
    final pages = [
      _buildAdminHome(),
      _buildKandidatListPage(),
      _buildTambahKandidatPage(),
      _buildHasilPage(),
      _buildRiwayatPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin E-PILKETLAS'),
        actions: [
          IconButton(
            onPressed: _logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(child: pages[_halamanAdmin]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _halamanAdmin,
        onDestinationSelected: (index) => setState(() => _halamanAdmin = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Kandidat'),
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'Tambah'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Hasil'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }

  Widget _buildAdminHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Dashboard Admin',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _buildStatCard('Jumlah Kandidat', '${_kandidat.length} kandidat'),
        _buildStatCard('Jumlah Pemilih', '${_pemilih.length} pemilih'),
        _buildStatCard('Total Suara', '$_totalSuara suara'),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildKandidatListPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Daftar Kandidat',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _kandidat.length; i++)
          _buildAdminKandidatCard(_kandidat[i], i + 1),
      ],
    );
  }

  Widget _buildAdminKandidatCard(Kandidat kandidat, int nomor) {
    return Card(
      child: ListTile(
        leading: _buildKandidatPhoto(kandidat, 56),
        title: Text('$nomor. ${kandidat.nama}'),
        subtitle: Text('Visi: ${kandidat.visi}\nMisi: ${kandidat.misi}'),
        trailing: Text('${kandidat.jumlahSuara} suara'),
      ),
    );
  }

  Widget _buildTambahKandidatPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tambah Kandidat',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _buildFotoPicker(),
        const SizedBox(height: 12),
        TextField(
          key: const Key('kandidat_nama'),
          controller: _kandidatController,
          decoration: const InputDecoration(
            labelText: 'Nama Kandidat',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('kandidat_visi'),
          controller: _visiController,
          decoration: const InputDecoration(
            labelText: 'Visi Kandidat',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('kandidat_misi'),
          controller: _misiController,
          decoration: const InputDecoration(
            labelText: 'Misi Kandidat',
            border: OutlineInputBorder(),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _tambahKandidat,
          icon: const Icon(Icons.add),
          label: const Text('Tambah Kandidat'),
        ),
      ],
    );
  }

  Widget _buildFotoPicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_fotoKandidatPath == null)
            Container(
              height: 130,
              color: Colors.grey.shade100,
              child: const Icon(Icons.image_outlined, size: 48),
            )
          else
            Image.file(
              File(_fotoKandidatPath!),
              height: 160,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pilihFotoKandidat,
            icon: const Icon(Icons.photo_library),
            label: Text(
              _fotoKandidatPath == null ? 'Pilih Foto' : 'Ganti Foto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Sejarah Voting',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        if (_riwayatVoting.isEmpty) const Text('Belum ada riwayat voting.'),
        for (final riwayat in _riwayatVoting)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(
              '${riwayat.namaPemilih} memilih ${riwayat.namaKandidat}',
            ),
            subtitle: Text(
              'NIS/NIM ${riwayat.nimPemilih} • ${_formatWaktu(riwayat.waktu)}',
            ),
          ),
      ],
    );
  }

  Widget _buildKandidatPhoto(Kandidat kandidat, double size) {
    final path = kandidat.fotoPath;
    if (path != null && path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildAvatar(kandidat.nama, size),
        ),
      );
    }
    return _buildAvatar(kandidat.nama, size);
  }

  Widget _buildAvatar(String nama, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        nama.characters.first.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}
