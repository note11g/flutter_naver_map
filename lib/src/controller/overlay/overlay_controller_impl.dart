part of flutter_naver_map;

class _NOverlayControllerImpl extends _NOverlayController with NChannelWrapper {
  final Map<NOverlayInfo, void Function(String)> overlayFunctionMap = {};

  @override
  late final MethodChannel channel;

  NOverlayInfo get _locationOverlayInfo =>
      NLocationOverlay._locationOverlayInfo;

  _NOverlayControllerImpl({required int viewId}) {
    initChannel(NChannel.overlayChannelName,
        id: viewId, handler: _handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    final query = _NOverlayQuery.fromQuery(call.method);

    log("_handleMethodCall: ${query.info}", name: "_OverlayControllerImpl");

    try {
      final func = overlayFunctionMap[query.info]!;
      func.call(query.methodName);
    } catch (e) {
      log("error!", error: e, name: "_OverlayControllerImpl");
    }
  }

  @override
  void add(NOverlayInfo info, NOverlay overlay) {
    overlayFunctionMap[info] = overlay._handle;
  }

  @override
  void deleteWithInfo(NOverlayInfo info) {
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
