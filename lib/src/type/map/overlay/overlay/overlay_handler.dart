part of "../../../../../flutter_naver_map.dart";

mixin _NOverlayHandler<O> {
  Function(O overlay)? get _onTapListener;

  set _onTapListener(Function(O overlay)? listener);

  void _handle(String methodName) {
    if (methodName == _onTapName) _onTapListener?.call(this as O);
  }

  void setOnTapListener(Function(O overlay) listener) =>
      _onTapListener = listener;

  void removeOnTapListener() => _onTapListener = null;

  static const _onTapName = "onTap";
}
