part of flutter_naver_map;

class NaverMap extends StatefulWidget {
  final NaverMapViewOptions options;
  final bool forceGesture;

  /*
    --- Events ---
  */
  final void Function(NaverMapController controller)? onMapReady;
  final void Function(NPoint point, NLatLng latLng)? onMapTapped;
  final void Function(NSymbolInfo symbolInfo)? onSymbolTapped;
  final void Function(NCameraUpdateReason reason, bool animated)?
      onCameraChange;
  final void Function()? onCameraIdle;
  final void Function(NSelectedIndoor? selectedIndoor)? onSelectedIndoorChanged;

  const NaverMap({
    super.key,
    this.options = const NaverMapViewOptions(),
    this.forceGesture = false,
    this.onMapReady,
    this.onMapTapped,
    this.onSymbolTapped,
    this.onCameraChange,
    this.onCameraIdle,
    this.onSelectedIndoorChanged,
  });

  @override
  State<NaverMap> createState() => _NaverMapState();
}

class _NaverMapState extends State<NaverMap>
    with _NaverMapControlHandler, NChannelWrapper {
  @override
  late final MethodChannel channel;
  late final NaverMapController controller;
  final controllerCompleter = Completer<void>();
  late NaverMapViewOptions nowViewOptions = widget.options;
  final mapSdk = NaverMapSdk.instance;

  @override
  Widget build(BuildContext context) {
    assert(mapSdk._isInitialized);

    if (mounted && nowViewOptions != widget.options) {
      nowViewOptions = widget.options;

      void updateOptionClosure([void _]) =>
          controller._updateOptions(nowViewOptions);

      controllerCompleter.isCompleted
          ? updateOptionClosure()
          : controllerCompleter.future.then(updateOptionClosure);
    }

    return _PlatformViewCreator.createPlatformView(
      viewType: NChannel.naverMapNativeView.str,
      gestureRecognizers: _createGestureRecognizers(widget.forceGesture),
      creationParams: widget.options.toNPayload(),
      onPlatformViewCreated: _onPlatformViewCreated,
      androidSdkVersion: mapSdk._androidSdkVersion,
    );
  }

  void _onPlatformViewCreated(int id) {
    initChannel(NChannel.naverMapNativeView, id: id, handler: handle);
    controller = NaverMapController._createController(channel,
        viewId: id,
        initialCameraPosition: widget.options.initialCameraPosition);
    controllerCompleter.complete();
  }

  Set<Factory<OneSequenceGestureRecognizer>> _createGestureRecognizers(
      bool forceGesture) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {};
    if (forceGesture) {
      gestureRecognizers
          .add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()));
    }
    return gestureRecognizers;
  }

  /*
    --- handler ---
  */

  @override
  void onMapReady() => widget.onMapReady?.call(controller);

  @override
  void onMapTapped(NPoint point, NLatLng latLng) =>
      widget.onMapTapped?.call(point, latLng);

  @override
  void onSymbolTapped(NSymbolInfo symbol) =>
      widget.onSymbolTapped?.call(symbol);

  @override
  void onCameraChange(NCameraUpdateReason reason, bool animated) =>
      widget.onCameraChange?.call(reason, animated);

  // like hot stream. (if needed, migrate to stream based event handling)
  @override
  void onCameraChangeWithCameraPosition(
      NCameraUpdateReason reason, bool animated, NCameraPosition position) {
    controller._updateNowCameraPositionData(position);
    widget.onCameraChange?.call(reason, animated);
  }

  @override
  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) =>
      widget.onSelectedIndoorChanged?.call(selectedIndoor);

  @override
  void onCameraIdle() => widget.onCameraIdle?.call();

  @override
  void dispose() {
    controller.dispose();
    disposeChannel();
    super.dispose();
  }
}
