part of "../../flutter_naver_map.dart";

class NAuthFailedException implements Exception {
  final String code;
  final String? message;

  NAuthFailedException._(this.code, this.message);

  @override
  String toString() => "NAuthFailedException(code: $code, message: $message)";
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
