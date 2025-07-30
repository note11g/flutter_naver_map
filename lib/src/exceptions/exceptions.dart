part of "../../flutter_naver_map.dart";

class _NRawNativeException implements Exception {
  final String code;
  final String? message;

  _NRawNativeException(this.code, this.message);

  factory _NRawNativeException.fromMessageable(dynamic messageable) {
    return _NRawNativeException(
      messageable["code"] as String,
      messageable["message"] as String?,
    );
  }

  @override
  String toString() => "NRawNativeException(code: $code, message: $message)";
}

/// 인증 실패 처리.
sealed class NAuthFailedException implements Exception {
  final String code;
  final String? message;

  NAuthFailedException._(this.code, this.message);

  @internal
  factory NAuthFailedException.fromMessageable(dynamic m) {
    final ex = _NRawNativeException.fromMessageable(m);
    return NAuthFailedException._internal(ex.code, ex.message);
  }

  factory NAuthFailedException._internal(String code, String? message) {
    return switch (code) {
      NUnauthorizedClientException._code =>
        NUnauthorizedClientException._(message),
      NQuotaExceededException._code => NQuotaExceededException._(message),
      NClientUnspecifiedException._code =>
        NClientUnspecifiedException._(message),
      _ => NAnotherAuthFailedException._(code, message),
    };
  }

  @override
  String toString() => "$runtimeType(code: $code, message: $message)";
}

/// - 잘못된 클라이언트 ID를 지정함
///
/// - 잘못된 클라이언트 유형을 사용함
///
/// - 콘솔에서 앱 패키지 이름을 잘못 등록함
class NUnauthorizedClientException extends NAuthFailedException {
  static const _code = "401";

  NUnauthorizedClientException._(String? message) : super._(_code, message);
}

/// - 콘솔에서 Maps 서비스를 선택하지 않음
///
/// - 사용 한도가 초과됨
class NQuotaExceededException extends NAuthFailedException {
  static const _code = "429";

  NQuotaExceededException._(String? message) : super._(_code, message);
}

/// 클라이언트 ID를 지정하지 않음
class NClientUnspecifiedException extends NAuthFailedException {
  static const _code = "800";

  NClientUnspecifiedException._(String? message) : super._(_code, message);
}

class NAnotherAuthFailedException extends NAuthFailedException {
  NAnotherAuthFailedException._(super.code, super.message) : super._();
}

/// Custom Style 관련 오류.
sealed class NStyleLoadFailedException implements Exception {
  final String code;
  final String? message;

  NStyleLoadFailedException._(this.code, this.message);

  factory NStyleLoadFailedException._fromMessageable(dynamic m) {
    final ex = _NRawNativeException.fromMessageable(m);
    return NStyleLoadFailedException._internal(ex.code, ex.message);
  }

  factory NStyleLoadFailedException._internal(String code, String? message) {
    return switch (code) {
      NInvalidStyleException._code => NInvalidStyleException(message),
      _ => NAnotherStyleLoadFailedException(code, message),
    };
  }

  @override
  String toString() => "$runtimeType(code: $code, message: $message)";
}

class NInvalidStyleException extends NStyleLoadFailedException {
  static const _code = "400";

  NInvalidStyleException(String? message) : super._(_code, message);
}

class NAnotherStyleLoadFailedException extends NStyleLoadFailedException {
  NAnotherStyleLoadFailedException(super.code, super.message) : super._();
}

class NOverlayNotAddedOnMapException implements Exception {
  final String? message;

  NOverlayNotAddedOnMapException(this.message);

  @override
  String toString() => "NOverlayNotAddedOnMapException(message: $message)";
}

class NInfoWindowAddedOnMarkerSetPositionException implements Exception {
  final String? message;

  NInfoWindowAddedOnMarkerSetPositionException(this.message);

  @override
  String toString() =>
      "NInfoWindowAddedOnMarkerSetPositionException(message: $message)";
}

class NUnknownTypeCastException implements Exception {
  final String? unknownValue;

  NUnknownTypeCastException({required this.unknownValue});

  @override
  String toString() => "NUnknownTypeCastException(unknownValue: $unknownValue)";
}
