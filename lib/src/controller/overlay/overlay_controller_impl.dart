part of flutter_naver_map;

class _NOverlayControllerImpl extends _NOverlayController {
  final Map<NOverlayInfo, void Function(String)> overlayFunctionMap = {};

  @override
  final MethodChannel channel;

  @override
  final NLocationOverlay locationOverlay = NLocationOverlay._();

  NOverlayInfo get _locationOverlayInfo => locationOverlay.info;

  _NOverlayControllerImpl(this.channel) {
    channel.setMethodCallHandler(_handleMethodCall);
    locationOverlay._addedOnMap(this);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    final info = NOverlayInfo._fromString(call.method);
    assert(info.method != null);

    log("_handleMethodCall: $info", name: "_OverlayControllerImpl");

    try {
      final func = overlayFunctionMap[info]!;
      func.call(info.method!);
    } catch (e) {
      log("error!", error: e, name: "_OverlayControllerImpl");
    }
  }

  @override
  void add(NOverlayInfo info, NOverlay overlay) {
    overlayFunctionMap[info] = overlay._handle;
  }

  @override
  void disposeWithInfo(NOverlayInfo info) {
    overlayFunctionMap.remove(info);
  }

  @override
  void clear(NOverlayType? type) {
    if (type != null) {
      overlayFunctionMap.removeWhere((keyInfo, _) => keyInfo.type == type);
    } else {
      // without location overlay
      final locationOverlay = overlayFunctionMap[_locationOverlayInfo];
      overlayFunctionMap.clear();
      if (locationOverlay != null) {
        overlayFunctionMap[_locationOverlayInfo] = locationOverlay;
      }
    }
  }
}
