import "dart:developer" show log;
import "dart:io" show Directory, File, FileSystemException;
import "dart:typed_data" show Uint8List;

import "package:crypto/crypto.dart" show sha256;
import "package:path_provider/path_provider.dart" show getTemporaryDirectory;

class ImageUtil {
  static final Map<String, String> _hashPathMap = {};

  static Future<String> saveImage(Uint8List bytes) async {
    final hash = _generateImageHashFromBytes(bytes);
    late final String path;
    if (_hashPathMap.containsKey(hash)) {
      path = _hashPathMap[hash]!;
      log("이미 저장된 이미지입니다. 저장된 path를 반환합니다. $path", name: "ImageSaveUtil");
    } else {
      path = await _makeFile(hash, bytes);
      _hashPathMap[hash] = path;
    }
    return path;
  }

  /* ----- Hashing ----- */

  static String _generateImageHashFromBytes(Uint8List bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /* ----- File ----- */

  static Future<String> _makeFile(String hash, Uint8List bytes) async {
    final tempDirPath = await _getDir().then((d) => d.path);
    final path = "$tempDirPath/$hash.png";
    try {
      final file = await File(path).writeAsBytes(bytes);
      return file.path;
    } on FileSystemException catch (e) {
      log("저장중 오류가 발생했습니다. 메시지: ${e.message}", name: "ImageSaveUtil");
      rethrow;
    }
  }

  /* ----- TempDir ----- */
  static Directory? _imageTempDir;

  static Future<Directory> _getDir() async {
    if (_imageTempDir == null) {
      final tempDir = await getTemporaryDirectory();
      final imageTempDir = await tempDir.createTemp("img_");
      _imageTempDir = imageTempDir;
    }
    return _imageTempDir!;
  }
}
