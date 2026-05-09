import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/voting_provider.dart';
import '../../data/models/kandidat.dart';
import '../../data/models/riwayat_voting.dart';
import '../../../../core/widgets/kandidat_photo_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/profile_dialog.dart';

enum PemilihScreen { beranda, detail, sukses, hasil }

class PemilihHomeScreen extends StatefulWidget {
  const PemilihHomeScreen({super.key});

  @override
  State<PemilihHomeScreen> createState() => _PemilihHomeScreenState();
}

class _PemilihHomeScreenState extends State<PemilihHomeScreen> {
  PemilihScreen _currentScreen = PemilihScreen.beranda;
  Kandidat? _selectedKandidat;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout() {
    context.read<AuthProvider>().logout();
  }

  Future<void> _confirmVote(Kandidat kandidat) async {
    final authProvider = context.read<AuthProvider>();
    final pemilih = authProvider.pemilihAktif;

    if (pemilih == null) return;

    if (pemilih.sudahMemilih) {
      _showMessage('Pilihan yang sudah dikirim tidak dapat diubah lagi.');
      return;
    }

    final confirmed = await showDialog<bool>(
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

    if (confirmed == true && mounted) {
      final votingProvider = context.read<VotingProvider>();
      final success = votingProvider.vote(pemilih, kandidat);

      if (success) {
        authProvider.markAsVoted(pemilih);
        setState(() {
          _selectedKandidat = null;
          _currentScreen = PemilihScreen.sukses;
        });
      } else {
        _showMessage('Hak suara kamu sudah digunakan.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SafeArea(child: _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentScreen == PemilihScreen.detail) {
      return AppBar(
        leading: BackButton(
          onPressed: () => setState(() => _currentScreen = PemilihScreen.beranda),
        ),
        title: const Text('PROFIL KANDIDAT'),
      );
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text(
        'E-PILKETLAS',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ProfileDialog(),
            );
          },
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          tooltip: 'Profil',
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    final pemilih = context.watch<AuthProvider>().pemilihAktif;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(
                  pemilih?.nama ?? 'Pemilih',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'NIS/NIM: ${pemilih?.nim ?? '-'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            selected: _currentScreen == PemilihScreen.beranda,
            onTap: () {
              setState(() => _currentScreen = PemilihScreen.beranda);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: const Text('Daftar Kandidat'),
            onTap: () {
              setState(() => _currentScreen = PemilihScreen.beranda);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Hasil Quick Count'),
            onTap: () {
              setState(() => _currentScreen = PemilihScreen.hasil);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Status Voting'),
            subtitle: Text(
              pemilih?.sudahMemilih == true ? 'Sudah Memilih' : 'Belum Memilih',
              style: TextStyle(
                color: pemilih?.sudahMemilih == true ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_currentScreen) {
      PemilihScreen.beranda => _buildBeranda(),
      PemilihScreen.detail => _buildDetail(),
      PemilihScreen.sukses => _buildSukses(),
      PemilihScreen.hasil => _buildHasil(showBackButton: true),
    };
  }

  Widget _buildBeranda() {
    final pemilih = context.watch<AuthProvider>().pemilihAktif;
    final kandidatList = context.watch<VotingProvider>().kandidat;
    final votingProvider = context.watch<VotingProvider>();
    final totalSuara = votingProvider.totalSuara;
    final riwayatVoting = votingProvider.riwayatVoting;

    if (pemilih == null) return const SizedBox();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.waving_hand, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selamat Datang, ${pemilih.nama}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        pemilih.sudahMemilih ? Icons.check_circle : Icons.pending_actions,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${pemilih.sudahMemilih ? 'Sudah Memilih' : 'Belum Memilih'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Suara',
                totalSuara.toString(),
                Icons.how_to_vote,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Kandidat',
                kandidatList.length.toString(),
                Icons.people,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.how_to_vote, color: Colors.blue, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Daftar Kandidat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih kandidat ketua kelas favorit Anda',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < kandidatList.length; i++)
          _buildKandidatCard(kandidatList[i], i + 1, pemilih.sudahMemilih),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.history, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            const Text(
              'History Pemilihan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Riwayat voting terbaru',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        if (riwayatVoting.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat voting',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...riwayatVoting.take(5).map((riwayat) => _buildHistoryCard(riwayat)),
        if (riwayatVoting.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _currentScreen = PemilihScreen.hasil),
              child: const Text('Lihat Semua Riwayat →'),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(RiwayatVoting riwayat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.check_circle, color: Colors.green.shade700),
        ),
        title: Text(
          '${riwayat.namaPemilih} memilih ${riwayat.namaKandidat}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'NIS/NIM: ${riwayat.nimPemilih} • ${_formatTime(riwayat.waktu)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      ),
    );
  }

  String _formatTime(DateTime waktu) {
    final now = DateTime.now();
    final difference = now.difference(waktu);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else {
      final jam = waktu.hour.toString().padLeft(2, '0');
      final menit = waktu.minute.toString().padLeft(2, '0');
      return '$jam:$menit';
    }
  }

  Widget _buildKandidatCard(Kandidat kandidat, int nomor, bool sudahMemilih) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => setState(() {
          _selectedKandidat = kandidat;
          _currentScreen = PemilihScreen.detail;
        }),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$nomor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  KandidatPhotoWidget(
                    nama: kandidat.nama,
                    fotoPath: kandidat.fotoPath,
                    size: 80,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kandidat.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kandidat No. $nomor',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _selectedKandidat = kandidat;
                        _currentScreen = PemilihScreen.detail;
                      }),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Lihat Detail'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: sudahMemilih ? null : () => _confirmVote(kandidat),
                      icon: const Icon(Icons.how_to_vote, size: 18),
                      label: const Text('VOTE'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail() {
    if (_selectedKandidat == null) {
      setState(() => _currentScreen = PemilihScreen.beranda);
      return const SizedBox();
    }

    final kandidat = _selectedKandidat!;
    final kandidatList = context.watch<VotingProvider>().kandidat;
    final nomor = kandidatList.indexOf(kandidat) + 1;
    final sudahMemilih = context.watch<AuthProvider>().pemilihAktif?.sudahMemilih ?? true;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: KandidatPhotoWidget(
            nama: kandidat.nama,
            fotoPath: kandidat.fotoPath,
            size: 160,
          ),
        ),
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
              child: CustomButton(
                onPressed: () => setState(() => _currentScreen = PemilihScreen.beranda),
                text: '[KEMBALI]',
                isOutlined: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                onPressed: sudahMemilih ? null : () => _confirmVote(kandidat),
                text: '[VOTE]',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSukses() {
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
            CustomButton(
              onPressed: () => setState(() => _currentScreen = PemilihScreen.hasil),
              text: 'LIHAT HASIL (Quick Count)',
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () => setState(() => _currentScreen = PemilihScreen.beranda),
              text: 'KEMBALI KE BERANDA',
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: _logout,
              text: '[LOGOUT]',
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasil({bool showBackButton = false}) {
    final votingProvider = context.watch<VotingProvider>();
    final hasil = votingProvider.getHasilVoting();
    final pemenang = votingProvider.getPemenang();
    final totalSuara = votingProvider.totalSuara;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _currentScreen = PemilihScreen.sukses),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ),
        const Text(
          'HASIL QUICK COUNT',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text('Total suara masuk: $totalSuara'),
        if (pemenang != null)
          Text(
            'Pemenang sementara: ${pemenang.nama}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 12),
        for (final kandidat in hasil)
          ListTile(
            leading: KandidatPhotoWidget(
              nama: kandidat.nama,
              fotoPath: kandidat.fotoPath,
              size: 48,
            ),
            title: Text(kandidat.nama),
            trailing: Text('${kandidat.jumlahSuara} suara'),
          ),
      ],
    );
  }
}
