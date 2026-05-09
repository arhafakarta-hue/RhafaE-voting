import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../voting/presentation/providers/voting_provider.dart';
import '../../../voting/data/models/kandidat.dart';
import '../../../../core/widgets/kandidat_photo_widget.dart';
import '../../../../core/constants/app_constants.dart';

class KandidatListWidget extends StatelessWidget {
  const KandidatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final kandidatList = context.watch<VotingProvider>().kandidat;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          AppConstants.daftarKandidatTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < kandidatList.length; i++)
          _buildKandidatCard(kandidatList[i], i + 1),
      ],
    );
  }

  Widget _buildKandidatCard(Kandidat kandidat, int nomor) {
    return Card(
      child: ListTile(
        leading: KandidatPhotoWidget(
          nama: kandidat.nama,
          fotoPath: kandidat.fotoPath,
          size: 56,
        ),
        title: Text('$nomor. ${kandidat.nama}'),
        subtitle: Text('Visi: ${kandidat.visi}\nMisi: ${kandidat.misi}'),
        trailing: Text('${kandidat.jumlahSuara} suara'),
      ),
    );
  }
}
