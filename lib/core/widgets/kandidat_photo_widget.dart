import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class KandidatPhotoWidget extends StatelessWidget {
  const KandidatPhotoWidget({
    super.key,
    required this.nama,
    required this.fotoPath,
    required this.size,
  });

  final String nama;
  final String? fotoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = fotoPath;

    // Jika tidak ada foto, tampilkan avatar
    if (path == null || path.isEmpty) {
      return _buildAvatar();
    }

    // Cek apakah asset image (path relatif tanpa 'assets/' atau dengan 'assets/')
    if (path.startsWith('images/') || path.startsWith('assets/images/')) {
      // Pastikan path mengandung 'assets/' di awal untuk Image.asset
      final assetPath = path.startsWith('assets/') ? path : 'assets/$path';
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          // ignore: unnecessary_underscores
          errorBuilder: (_, __, ___) => _buildAvatar(),
        ),
      );
    }

    // Untuk web, cek apakah base64 atau URL
    if (kIsWeb) {
      if (path.startsWith('data:image')) {
        // Base64 image
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            _base64ToBytes(path),
            width: size,
            height: size,
            fit: BoxFit.cover,
            // ignore: unnecessary_underscores
            errorBuilder: (_, __, ___) => _buildAvatar(),
          ),
        );
      } else if (path.startsWith('http')) {
        // Network image
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            path,
            width: size,
            height: size,
            fit: BoxFit.cover,
            // ignore: unnecessary_underscores
            errorBuilder: (_, __, ___) => _buildAvatar(),
          ),
        );
      } else {
        // Fallback to avatar for web
        return _buildAvatar();
      }
    }

    // Untuk platform non-web, gunakan Image.file
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        // ignore: unnecessary_underscores
        errorBuilder: (_, __, ___) => _buildAvatar(),
      ),
    );
  }

  Uint8List _base64ToBytes(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }

  Widget _buildAvatar() {
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
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
