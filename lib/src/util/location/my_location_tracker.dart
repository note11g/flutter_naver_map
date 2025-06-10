part of "../../../flutter_naver_map.dart";

abstract class NMyLocationTracker with AppLifeCycleBinder {
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
      NLocationTrackingMode.follow ||
      NLocationTrackingMode.noFollow =>
        NLocationOverlay.defaultSubIcon,
      NLocationTrackingMode.none => null,
    };

    locationOverlay.setIcon(NLocationOverlay.defaultIcon);
    locationOverlay.setSubIcon(subIcon);
    locationOverlay.setIsVisible(mode != NLocationTrackingMode.none);
  }

  void disposeLocationService() {}

  void onLocationChanged(NLatLng latLng, NLocationOverlay locationOverlay,
      NaverMapController controller, NLocationTrackingMode mode) {
    locationOverlay.setPosition(latLng);
    if (mode case NLocationTrackingMode.follow || NLocationTrackingMode.face) {
      controller.updateCamera(NCameraUpdate.withParams(target: latLng)
        ..setReason(NCameraUpdateReason.location));
    }
  }

  void onHeadingChanged(double heading, NLocationOverlay locationOverlay,
      NaverMapController controller, NLocationTrackingMode mode) {
    locationOverlay.setBearing(heading);
    if (mode case NLocationTrackingMode.face) {
      controller.updateCamera(NCameraUpdate.withParams(bearing: heading)
        ..setReason(NCameraUpdateReason.location));
    }
  }

  void onCameraChanged(
      NCameraPosition position,
      NCameraUpdateReason reason,
      NLocationOverlay locationOverlay,
      NaverMapController controller,
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

  FutureOr<bool> _startTracking(NLocationTrackingMode mode,
      NLocationOverlay locationOverlay, NaverMapController controller) async {
    _isLoading.value = true;
    final currentLocation = await startLocationService()
        .whenComplete(() => _isLoading.value = false);
    if (currentLocation == null) return false; // guard
    bindAppLifecycleChange();
    onLocationChanged(currentLocation, locationOverlay, controller, mode);
    return true;
  }

  FutureOr<void> _stopTracking() async {
    unbindAppLifecycleChange();
    _cancelCameraChangedSubscription();
    _cancelLocationSubscription();
    _cancelHeadingSubscription();
    disposeLocationService();
    _isLoading.value = false;
  }

  // mark: called by [NaverMapControllerImpl.setLocationTrackingMode]
  FutureOr<void> _onChangeTrackingMode(
      NLocationOverlay locationOverlay,
      NaverMapController controller,
      NLocationTrackingMode mode,
      NLocationTrackingMode oldMode) async {
    if (oldMode == mode) return; // guard distinct

    final needStart = !_nowTracking && mode != NLocationTrackingMode.none;
    final needStop = _nowTracking && mode == NLocationTrackingMode.none;
    if (needStart) {
      final started = await _startTracking(mode, locationOverlay, controller);
      if (!started) return;
      _nowTracking = true;
    } else if (needStop) {
      _stopTracking();
      _nowTracking = false;
    }

    onChangeTrackingMode(locationOverlay, mode);
    if (mode case NLocationTrackingMode.none) return;

    _startLocationSubscription(locationOverlay, controller, mode);
    _startCameraChangedSubscription(locationOverlay, controller, mode);

    if (mode case NLocationTrackingMode.none) {
      _cancelHeadingSubscription();
    } else {
      _startHeadingSubscription(locationOverlay, controller, mode);
    }
  }

  void Function(NLatLng)? _currentCapturedLocationLambda;
  void Function(double)? _currentCapturedHeadingLambda;

  /* --- LocationStream --- */
  void _startLocationSubscription(NLocationOverlay locationOverlay,
      NaverMapController controller, NLocationTrackingMode mode) {
    _locationStreamSub?.cancel();
    _currentCapturedLocationLambda = (NLatLng location) =>
        onLocationChanged(location, locationOverlay, controller, mode);
    _locationStreamSub = locationStream.listen(_currentCapturedLocationLambda!);
  }

  bool _pauseLocationSubscription() {
    if (_locationStreamSub case StreamSubscription<NLatLng> sub) {
      log("pause locationSubscription", name: "NMyLocationTracker");
      sub.cancel();
      _locationStreamSub = null;
      return true;
    } else {
      return false;
    }
  }

  bool get _isPausedLocationSubscription {
    return _locationStreamSub == null && _currentCapturedLocationLambda != null;
  }

  void _resumeLocationSubscription() {
    if (!_isPausedLocationSubscription) return;
    log("resume LocationSubscription", name: "NMyLocationTracker");
    _locationStreamSub = locationStream.listen(_currentCapturedLocationLambda!);
  }

  void _cancelLocationSubscription() {
    _locationStreamSub?.cancel();
    _locationStreamSub = null;
    _currentCapturedLocationLambda = null;
    _nowTracking = false;
  }

  /* --- HeadingStream --- */
  void _startHeadingSubscription(NLocationOverlay locationOverlay,
      NaverMapController controller, NLocationTrackingMode mode) {
    _headingStreamSub?.cancel();
    _currentCapturedHeadingLambda = (double heading) =>
        onHeadingChanged(heading, locationOverlay, controller, mode);
    _headingStreamSub = headingStream.listen(_currentCapturedHeadingLambda!);
  }

  bool _pauseHeadingSubscription() {
    if (_headingStreamSub case StreamSubscription<double> sub) {
      log("pause headingSubscription", name: "NMyLocationTracker");
      sub.cancel();
      _headingStreamSub = null;
      return true;
    } else {
      return false;
    }
  }

  bool get _isPausedHeadingSubscription {
    return _headingStreamSub == null && _currentCapturedHeadingLambda != null;
  }

  void _resumeHeadingSubscription() {
    if (!_isPausedHeadingSubscription) return;
    log("resume headingSubscription", name: "NMyLocationTracker");
    _headingStreamSub = headingStream.listen(_currentCapturedHeadingLambda!);
  }

  void _cancelHeadingSubscription() {
    _headingStreamSub?.cancel();
    _headingStreamSub = null;
    _currentCapturedHeadingLambda = null;
  }

  /* --- CameraChangedStream --- */

  void _startCameraChangedSubscription(NLocationOverlay locationOverlay,
      NaverMapController controller, NLocationTrackingMode mode) {
    _onCameraChangedSubscription?.cancel();
    _onCameraChangedSubscription = controller._nowCameraPositionStream.listen(
        (e) => onCameraChanged(
            e.position, e.reason, locationOverlay, controller, mode));
  }

  void _cancelCameraChangedSubscription() {
    _onCameraChangedSubscription?.cancel();
    _onCameraChangedSubscription = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_locationStreamSub != null) _pauseLocationSubscription();
      if (_headingStreamSub != null) _pauseHeadingSubscription();
    } else if (state == AppLifecycleState.resumed) {
      if (_isPausedLocationSubscription) _resumeLocationSubscription();
      if (_isPausedHeadingSubscription) _resumeHeadingSubscription();
    }
  }
}
