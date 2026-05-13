import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Copies a file from temporary/cache path to the app's persistent documents directory.
  /// Returns the new persistent path, or original path if copy fails/file already in app dir.
  static Future<String?> saveFileToAppDir(String? tempPath) async {
    if (tempPath == null || tempPath.isEmpty) return null;
    try {
      final file = File(tempPath);
      if (!await file.exists()) return tempPath;

      final appDir = await getApplicationDocumentsDirectory();

      // If the file is already inside the application documents directory, no need to copy
      if (p.isWithin(appDir.path, tempPath)) {
        return tempPath;
      }

      // Generate a unique filename using timestamp
      final ext = p.extension(tempPath);
      final baseName = p.basenameWithoutExtension(tempPath);
      // Clean baseName to avoid weird path issues
      final safeBaseName = baseName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$safeBaseName$ext';

      final persistentPath = p.join(appDir.path, fileName);
      final savedFile = await file.copy(persistentPath);
      return savedFile.path;
    } catch (e) {
      // Fallback to original path if any exception occurs
      return tempPath;
    }
  }

  /// Copies a list of files to persistent directory
  static Future<List<String>> saveFilesToAppDir(List<String> tempPaths) async {
    final List<String> savedPaths = [];
    for (final path in tempPaths) {
      final saved = await saveFileToAppDir(path);
      if (saved != null) {
        savedPaths.add(saved);
      }
    }
    return savedPaths;
  }
}
