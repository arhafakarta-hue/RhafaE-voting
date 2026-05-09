import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  static const String _folderName = 'kandidat_photos';

  // Get application documents directory
  static Future<Directory> _getStorageDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(path.join(appDir.path, _folderName));

    // Create directory if it doesn't exist
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }

    return photoDir;
  }

  // Save image to storage
  static Future<String?> saveImage(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final storageDir = await _getStorageDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(sourcePath)}';
      final destinationPath = path.join(storageDir.path, fileName);

      // Copy file to storage
      await sourceFile.copy(destinationPath);

      return destinationPath;
    } catch (e) {
      // ignore: avoid_print
      print('Error saving image: $e');
      return null;
    }
  }

  // Delete image from storage
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting image: $e');
      return false;
    }
  }

  // Get all images in storage
  static Future<List<String>> getAllImages() async {
    try {
      final storageDir = await _getStorageDirectory();
      final files = storageDir.listSync();

      return files
          .whereType<File>()
          .map((file) => file.path)
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting images: $e');
      return [];
    }
  }

  // Check if image exists
  static Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  // Get storage directory path
  static Future<String> getStoragePath() async {
    final dir = await _getStorageDirectory();
    return dir.path;
  }
}
