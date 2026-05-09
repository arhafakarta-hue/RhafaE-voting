import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../voting/presentation/providers/voting_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../services/image_storage_service.dart';

class TambahKandidatWidget extends StatefulWidget {
  const TambahKandidatWidget({super.key});

  @override
  State<TambahKandidatWidget> createState() => _TambahKandidatWidgetState();
}

class _TambahKandidatWidgetState extends State<TambahKandidatWidget> {
  final _namaController = TextEditingController();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _fotoPath;

  @override
  void dispose() {
    _namaController.dispose();
    _visiController.dispose();
    _misiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final foto = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (foto == null) return;

    if (kIsWeb) {
      // For web, convert to base64
      final bytes = await foto.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() => _fotoPath = 'data:image/png;base64,$base64Image');
    } else {
      // For mobile/desktop, use file path
      setState(() => _fotoPath = foto.path);
    }
  }

  void _tambahKandidat() async {
    if (_namaController.text.trim().isEmpty ||
        _visiController.text.trim().isEmpty ||
        _misiController.text.trim().isEmpty) {
      _showMessage(AppConstants.emptyCandidateFieldsError);
      return;
    }

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String? savedImagePath;
    if (_fotoPath != null) {
      // Save image to permanent storage
      savedImagePath = await ImageStorageService.saveImage(_fotoPath!);
      if (savedImagePath == null) {
        if (mounted) {
          Navigator.pop(context); // Close loading
          _showMessage('Gagal menyimpan foto. Silakan coba lagi.');
        }
        return;
      }
    }

    if (!mounted) return;
    final votingProvider = context.read<VotingProvider>();
    final success = votingProvider.tambahKandidat(
      _namaController.text.trim(),
      _visiController.text.trim(),
      _misiController.text.trim(),
      savedImagePath,
    );

    if (mounted) Navigator.pop(context); // Close loading

    if (success) {
      _namaController.clear();
      _visiController.clear();
      _misiController.clear();
      setState(() => _fotoPath = null);
      if (mounted) {
        _showMessage('Kandidat berhasil ditambahkan dengan foto tersimpan!');
      }
    } else {
      // Delete saved image if kandidat creation failed
      if (savedImagePath != null) {
        await ImageStorageService.deleteImage(savedImagePath);
      }
      if (mounted) {
        _showMessage(AppConstants.duplicateCandidateError);
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          AppConstants.tambahKandidatTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _buildFotoPicker(),
        const SizedBox(height: 12),
        TextField(
          key: const Key('kandidat_nama'),
          controller: _namaController,
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
        CustomButton(
          onPressed: _tambahKandidat,
          text: 'Tambah Kandidat',
          icon: Icons.add,
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
          if (_fotoPath == null)
            Container(
              height: 130,
              color: Colors.grey.shade100,
              child: const Icon(Icons.image_outlined, size: 48),
            )
          else
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: _fotoPath!.startsWith('data:image')
                  ? Image.memory(
                      _base64ToBytes(_fotoPath!),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_fotoPath!),
                      fit: BoxFit.cover,
                    ),
            ),
          const SizedBox(height: 12),
          CustomButton(
            onPressed: _pickImage,
            text: _fotoPath == null ? 'Pilih Foto' : 'Ganti Foto',
            icon: Icons.photo_library,
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Uint8List _base64ToBytes(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }
}
