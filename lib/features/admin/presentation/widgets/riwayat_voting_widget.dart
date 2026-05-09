import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../voting/presentation/providers/voting_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class RiwayatVotingWidget extends StatelessWidget {
  const RiwayatVotingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final riwayatList = context.watch<VotingProvider>().riwayatVoting;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          AppConstants.riwayatTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        if (riwayatList.isEmpty)
          const EmptyStateWidget(
            message: 'Belum ada riwayat voting.',
            icon: Icons.history,
          )
        else
          for (final riwayat in riwayatList)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(
                '${riwayat.namaPemilih} memilih ${riwayat.namaKandidat}',
              ),
              subtitle: Text(
                'NIS/NIM ${riwayat.nimPemilih} • ${DateTimeUtils.formatTime(riwayat.waktu)}',
              ),
            ),
      ],
    );
  }
}
