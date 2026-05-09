import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../voting/presentation/providers/voting_provider.dart';
import '../../../../core/constants/app_constants.dart';

class AdminDashboardWidget extends StatelessWidget {
  const AdminDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final votingProvider = context.watch<VotingProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          AppConstants.dashboardTitle,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Jumlah Kandidat',
          '${votingProvider.kandidat.length} kandidat',
        ),
        _buildStatCard(
          'Jumlah Pemilih',
          '${authProvider.pemilih.length} pemilih',
        ),
        _buildStatCard(
          'Total Suara',
          '${votingProvider.totalSuara} suara',
        ),
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
}
