import 'package:flutter/material.dart';

class AppAssets {
  static const String logoPath = 'assets/images/logo_unpra.png';

  // Logo widget with fallback
  static Widget logo({double size = 92}) {
    return Image.asset(
      logoPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback jika logo tidak ditemukan
        return logoPlaceholder(size: size);
      },
    );
  }

  // Placeholder logo widget
  static Widget logoPlaceholder({double size = 92}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: size * 0.4,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 4),
          Text(
            'UNPRA',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
