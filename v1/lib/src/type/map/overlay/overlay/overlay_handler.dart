part of "../../../../../flutter_naver_map.dart";

mixin _NOverlayHandler<O> {
  Function(O overlay)? get _onTapListener;

  set _onTapListener(Function(O overlay)? listener);

  void _handle(String methodName) {
    if (methodName == _onTapName) _onTapListener?.call(this as O);
  }

  /// 오버레이가 사용자에 의해 터치되었을 때 실행할 함수를 지정합니다.
  void setOnTapListener(Function(O overlay) listener) =>
      _onTapListener = listener;

  /// 오버레이가 사용자에 의해 터치되었을 때 실행할 함수를 제거합니다.
  void removeOnTapListener() => _onTapListener = null;

  static const _onTapName = "onTap";
}
