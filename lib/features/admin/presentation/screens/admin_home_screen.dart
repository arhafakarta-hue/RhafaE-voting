import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/admin_dashboard_widget.dart';
import '../widgets/kandidat_list_widget.dart';
import '../widgets/tambah_kandidat_widget.dart';
import '../widgets/hasil_voting_widget.dart';
import '../widgets/riwayat_voting_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentPageIndex = 0;

  void _logout() {
    context.read<AuthProvider>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboardWidget(),
      const KandidatListWidget(),
      const TambahKandidatWidget(),
      const HasilVotingWidget(isAdminView: true),
      const RiwayatVotingWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.adminTitle),
        actions: [
          IconButton(
            onPressed: _logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(child: pages[_currentPageIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) {
          setState(() => _currentPageIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: AppConstants.navBeranda,
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: AppConstants.navKandidat,
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle),
            label: AppConstants.navTambah,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: AppConstants.navHasil,
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: AppConstants.navRiwayat,
          ),
        ],
      ),
    );
  }
}
