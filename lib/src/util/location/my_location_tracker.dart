part of "../../../flutter_naver_map.dart";

abstract class NMyLocationTracker {
  Stream<NLatLng> get locationStream;

  Stream<double> get headingStream;

  /// 위치 추적을 시작할 때마다 실행됩니다.
  ///
  /// 반환 값으로 현재 위치를 반환 해야 합니다.
  ///
  /// [NLatLng]를 반환할 경우, 추적 종료(none 혹은 위젯 dispose) 전까지 해당 메서드는 실행되지 않으며
  ///
  /// [null]를 반환할 경우, 지도 위젯이 다시 시작되지 않더라도 다시 위치 추적을 요청하는 경우에 실행합니다.
  Future<NLatLng?> startLocationService();

  void onChangeTrackingMode(
      NLocationOverlay locationOverlay, NLocationTrackingMode mode) {
    final subIcon = switch (mode) {
      NLocationTrackingMode.face => NLocationOverlay.faceModeSubIcon,
      NLocationTrackingMode.follow => NLocationOverlay.defaultSubIcon,
      NLocationTrackingMode.noFollow || NLocationTrackingMode.none => null,
    };

    locationOverlay.setIcon(NLocationOverlay.defaultIcon);
    locationOverlay.setSubIcon(subIcon);
    locationOverlay.setIsVisible(mode != NLocationTrackingMode.none);
  }

  // mark: called by [NaverMapControllerImpl]
  void disposeLocationService() {
    _cancelCameraChangedSubscription();
    _cancelLocationStream();
    _cancelHeadingStream();
  }

  void onLocationChanged(
      NLocationOverlay locationOverlay,
      NaverMapController controller,
      NLatLng latLng,
      NLocationTrackingMode mode) {
    locationOverlay.setPosition(latLng);
    if (mode case NLocationTrackingMode.follow || NLocationTrackingMode.face) {
      controller.updateCamera(NCameraUpdate.withParams(target: latLng)
        ..setReason(NCameraUpdateReason.location));
    }
  }

  void onHeadingChanged(
      NLocationOverlay locationOverlay,
      NaverMapController controller,
      double heading,
      NLocationTrackingMode mode) {
    locationOverlay.setBearing(heading);
    if (mode case NLocationTrackingMode.face) {
      controller.updateCamera(NCameraUpdate.withParams(bearing: heading)
        ..setReason(NCameraUpdateReason.location));
    }
  }

  void onCameraChanged(
      NLocationOverlay locationOverlay,
      NaverMapController controller,
      NCameraPosition position,
      NCameraUpdateReason reason,
      NLocationTrackingMode mode) {
    if (reason case NCameraUpdateReason.location) return;
    if (mode
        case NLocationTrackingMode.none || NLocationTrackingMode.noFollow) {
      return;
    }

    controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
  }

  ValueListenable<bool> get isLoading => _isLoading;

  //
  // --- Private Members and Methods ---
  //
  bool _nowTracking = false;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  StreamSubscription<NLatLng>? _locationStreamSub;
  StreamSubscription<double>? _headingStreamSub;
  StreamSubscription<_OnCameraChangedParams>? _onCameraChangedSubscription;

  // mark: called by [NaverMapControllerImpl.setLocationTrackingMode]
  FutureOr<void> _onChangeTrackingMode(
      NLocationOverlay locationOverlay,
      NaverMapController controller,
      NLocationTrackingMode mode,
      NLocationTrackingMode oldMode) async {
    if (oldMode == mode) return; // guard distinct

    final needStart = !_nowTracking && mode != NLocationTrackingMode.none;
    if (needStart) {
      assert(mode != NLocationTrackingMode.none);
      _isLoading.value = true;
      final currentLocation = await startLocationService()
          .whenComplete(() => _isLoading.value = false);
      if (currentLocation == null) return; // guard
      _nowTracking = true;
    }

    onChangeTrackingMode(locationOverlay, mode);

    // todo:
    //    - lifecycle callback (when background, stop subscription)

    if (mode != NLocationTrackingMode.none) {
      _locationStreamSub?.cancel();
      _locationStreamSub = locationStream.listen((location) =>
          onLocationChanged(locationOverlay, controller, location, mode));
      _onCameraChangedSubscription?.cancel();
      _onCameraChangedSubscription = controller._nowCameraPositionStream.listen(
          (e) => onCameraChanged(
              locationOverlay, controller, e.position, e.reason, mode));
    } else {
      _cancelLocationStream();
    }

    if (mode case NLocationTrackingMode.follow || NLocationTrackingMode.face) {
      _headingStreamSub?.cancel();
      _headingStreamSub = headingStream.listen((heading) =>
          onHeadingChanged(locationOverlay, controller, heading, mode));
    } else {
      _cancelHeadingStream();
    }
  }

  void _cancelLocationStream() {
    _locationStreamSub?.cancel();
    _locationStreamSub = null;
    _nowTracking = false;
  }

  void _cancelHeadingStream() {
    _headingStreamSub?.cancel();
    _headingStreamSub = null;
  }

  void _cancelCameraChangedSubscription() {
    _onCameraChangedSubscription?.cancel();
    _onCameraChangedSubscription = null;
  }
}

// todo: NDefaultMyLocationTracker
