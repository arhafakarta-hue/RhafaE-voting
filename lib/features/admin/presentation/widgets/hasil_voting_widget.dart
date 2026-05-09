import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../voting/presentation/providers/voting_provider.dart';
import '../../../../core/widgets/kandidat_photo_widget.dart';
import '../../../../core/constants/app_constants.dart';

class HasilVotingWidget extends StatelessWidget {
  const HasilVotingWidget({super.key, this.isAdminView = false});

  final bool isAdminView;

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();
    final hasil = votingProvider.getHasilVoting();
    final pemenang = votingProvider.getPemenang();
    final totalSuara = votingProvider.totalSuara;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          AppConstants.hasilTitle,
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
