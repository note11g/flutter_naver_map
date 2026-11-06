import "dart:convert" show utf8;
import "dart:developer" show log;
import "dart:io"
    show Directory, File, FileSystemEntity, FileSystemException, PathNotFoundException;
import "dart:typed_data" show Uint8List;

import "package:crypto/crypto.dart" show sha256;
import "package:path_provider/path_provider.dart"
    show getApplicationSupportDirectory, getTemporaryDirectory;

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
      try {
        return (await File(path).writeAsBytes(bytes)).path;
      } on PathNotFoundException {
        // 앱이 켜져 있는 동안 폴더가 지워졌다(저장공간 부족 시 OS 정리 등).
        // 폴더를 다시 만들고 한 번 더 저장한다. 그렇지 않으면 앱을 다시 켤 때까지
        // 모든 마커 이미지 저장이 실패한다.
        await Directory(tempDirPath).create(recursive: true);
        return (await File(path).writeAsBytes(bytes)).path;
      }
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

  // 캐시 폴더(getTemporaryDirectory)는 Android 가 저장공간이 부족하면 앱 실행 중에도
  // 지운다. 그러면 이미 저장한 마커 이미지 파일이 사라져 지도에 아이콘이 뜨지 않는다.
  // 그래서 OS 가 임의로 지우지 않는 앱 전용 폴더에 둔다. 이전 실행의 폴더는 아래
  // _cleanUpPreviousTempDir 가 시작 시 지우므로 쌓이지 않는다.
  static Future<Directory> _initTempDir() async {
    final baseDir = await getApplicationSupportDirectory();
    final targetFolderDir = Directory("${baseDir.path}/$_newTempFolderPath");
    await _cleanUpCacheDirFolder();
    await _cleanUpLegacyTempDir(targetFolderDir);
    await _cleanUpPreviousTempDir(targetFolderDir);
    final imageTempDirParent = await targetFolderDir.create();
    final imageTempDir = await imageTempDirParent.createTemp(_newPathPrefix);
    return imageTempDir;
  }

  /// 이전 버전이 캐시 폴더에 만들던 fnm1_img 폴더를 지운다.
  static Future<void> _cleanUpCacheDirFolder() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final old = Directory("${tempDir.path}/$_newTempFolderPath");
      if (await old.exists()) _deleteQuietly(old); // not wait.
    } catch (e) {
      log("캐시 폴더의 이전 이미지 폴더 정리 중 오류 무시: $e", name: "ImageUtil");
    }
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
