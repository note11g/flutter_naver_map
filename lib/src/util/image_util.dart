import "dart:convert" show utf8;
import "dart:developer" show log;
import "dart:io" show Directory, File, FileSystemEntity, FileSystemException;
import "dart:typed_data" show Uint8List;

import "package:crypto/crypto.dart" show sha256;
import "package:path_provider/path_provider.dart" show getTemporaryDirectory;

class ImageUtil {
  // todo: maxCacheCount or maxCacheSize 도입
  static final Map<String, String> _hashPathMap = {};

  static Future<String> saveImage(Uint8List bytes, [String? cacheKey]) async {
    final key = cacheKey ?? _generateImageHashFromBytes(bytes);
    late final String path;
    if (_hashPathMap.containsKey(key)) {
      path = _hashPathMap[key]!;
      log("이미 저장된 이미지입니다. 저장된 path를 반환합니다. $path", name: "ImageSaveUtil");
    } else {
      path = await _makeFile(key, bytes);
      _hashPathMap[key] = path;
    }
    return path;
  }

  /* ----- Hashing ----- */

  static String _generateImageHashFromBytes(Uint8List bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /* ----- File ----- */

  static Future<String> _makeFile(String key, Uint8List bytes) async {
    final tempDirPath = await _getDir().then((d) => d.path);
    final hashedKey = sha256.convert(utf8.encode(key)).toString();
    final path = "$tempDirPath/$hashedKey.png";
    try {
      final file = await File(path).writeAsBytes(bytes);
      return file.path;
    } on FileSystemException catch (e) {
      log("저장중 오류가 발생했습니다. 메시지: ${e.message}", name: "ImageSaveUtil");
      rethrow;
    }
  }

  /* ----- TempDir ----- */
  // 초기화를 Future 로 기억해 동시에 들어온 호출이 같은 초기화를 기다리게 한다.
  // 결과(Directory)만 기억하면 첫 초기화가 끝나기 전에 들어온 호출마다 초기화가 돌고,
  // 각 초기화의 이전 폴더 정리가 다른 호출이 방금 만든 폴더를 지운다.
  // (앱 시작 직후 마커 비트맵을 여러 개 동시에 저장할 때 발생)
  static Future<Directory>? _imageTempDir;

  static Future<Directory> _getDir() {
    return _imageTempDir ??=
        _initTempDir().catchError((Object e, StackTrace st) {
      _imageTempDir = null; // 실패하면 다음 호출에서 다시 시도한다.
      Error.throwWithStackTrace(e, st);
    });
  }

  static Future<Directory> _initTempDir() async {
    final tempDir = await getTemporaryDirectory();
    final targetFolderDir = Directory("${tempDir.path}/$_newTempFolderPath");
    await _cleanUpLegacyTempDir(targetFolderDir);
    await _cleanUpPreviousTempDir(targetFolderDir);
    final imageTempDirParent = await targetFolderDir.create();
    final imageTempDir = await imageTempDirParent.createTemp(_newPathPrefix);
    return imageTempDir;
  }

  static Future<void> _cleanUpPreviousTempDir(Directory imgTempDir) async {
    // 보조적 정리 작업이므로 어떤 예외도 init 을 실패시키지 않도록 전체를 감싼다.
    // (list()/toList() 스트림 순회 중 동시 삭제·권한 등으로 FileSystemException 가능)
    try {
      if (!(await imgTempDir.exists())) return; // guard.

      final previousCacheFolderStream = imgTempDir.list();
      final previousCacheFolders = await previousCacheFolderStream.toList();

      for (final folder in previousCacheFolders) {
        _deleteQuietly(folder); // not wait.
      }
    } catch (e) {
      log("이전 임시 디렉터리 정리 중 오류 무시: $e", name: "ImageUtil");
    }
  }

  static Future<void> _cleanUpLegacyTempDir(Directory newCacheFolderDir) async {
    // 보조적 정리 작업이므로 어떤 예외도 init 을 실패시키지 않도록 전체를 감싼다.
    try {
      // new version folder detected. return fast.
      if (await newCacheFolderDir.exists()) return;

      final tempDir = await getTemporaryDirectory();
      final subDirSteam = tempDir.list();

      await for (final dir in subDirSteam) {
        if (dir case Directory(:final path)) {
          final name = path.split("/").last;
          if (name.startsWith(_oldV1PathPrefix)) {
            _deleteQuietly(dir); // not wait.
          }
        }
      }
    } catch (e) {
      log("레거시 임시 디렉터리 정리 중 오류 무시: $e", name: "ImageUtil");
    }
  }

  /// fire-and-forget 삭제. 앱 시작 시 이전 캐시 폴더를 정리할 때, 동시 init 경합이나
  /// 이미 삭제된 경로로 인해 PathNotFoundException 이 unhandled async exception 으로
  /// 터지던 문제를 방지한다. (delete 를 await 하지 않으므로 시작을 블로킹하지 않음)
  static void _deleteQuietly(FileSystemEntity entity) {
    entity.delete(recursive: true).catchError((_) => entity);
  }

  /// using <= 1.4.2
  static const _oldV1PathPrefix = "img_";

  /// currently using (1.4.3~)
  static const _newTempFolderPath = "fnm1_img";
  static const _newPathPrefix = "fnm1_img_";
}
