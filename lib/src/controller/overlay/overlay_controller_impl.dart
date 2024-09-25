part of "../../../flutter_naver_map.dart";

class _OverlayHandleAndRemoveHelper {
  final void Function(String) handler;
  final void Function(int overlayControllerViewId) remover;

  const _OverlayHandleAndRemoveHelper(this.handler, this.remover);
}

class _NOverlayControllerImpl extends _NOverlayController with NChannelWrapper {
  final Map<NOverlayInfo, _OverlayHandleAndRemoveHelper>
      overlayHandleAndRemoveHelperMap = {};

  @override
  late final MethodChannel channel;
  @override
  final int viewId;

  NOverlayInfo get _locationOverlayInfo =>
      NLocationOverlay._locationOverlayInfo;

  _NOverlayControllerImpl({required this.viewId}) {
    initChannel(NChannel.overlayChannelName,
        id: viewId, handler: _handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    final query = _NOverlayQuery.fromQuery(call.method);

    log("_handleMethodCall: ${query.info}", name: "_OverlayControllerImpl");

    try {
      final handler = overlayHandleAndRemoveHelperMap[query.info]!.handler;
      handler.call(query.methodName);
    } catch (e, stackTrace) {
      log("error!",
          error: e, name: "_OverlayControllerImpl", stackTrace: stackTrace);
    }
  }

  @override
  void add(NOverlayInfo info, NOverlay overlay) {
    overlayHandleAndRemoveHelperMap[info] =
        _OverlayHandleAndRemoveHelper(overlay._handle, overlay._removedOnMap);
  }

  @override
  void deleteWithInfo(NOverlayInfo info) {
    final helper = overlayHandleAndRemoveHelperMap[info];
    assert(helper != null, "Not Added or Already Deleted this overlay : $info");
    helper?.remover.call(viewId);
    overlayHandleAndRemoveHelperMap.remove(info);
  }

  @override
  void clear(NOverlayType? type) {
    if (type != null) {
      overlayHandleAndRemoveHelperMap.removeWhere((info, helper) {
        final needRemove = info.type == type;
        if (needRemove) helper.remover.call(viewId);
        return needRemove;
      });
    } else {
      // without location overlay
      final locationOverlayHelper =
          overlayHandleAndRemoveHelperMap[_locationOverlayInfo];
      overlayHandleAndRemoveHelperMap.remove(_locationOverlayInfo);

      overlayHandleAndRemoveHelperMap
          .forEach((info, helper) => helper.remover.call(viewId));
      overlayHandleAndRemoveHelperMap.clear();

      if (locationOverlayHelper != null) {
        overlayHandleAndRemoveHelperMap[_locationOverlayInfo] =
            locationOverlayHelper;
      }
    }
  }
}
