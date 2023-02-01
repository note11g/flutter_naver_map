part of flutter_naver_map;

class NaverMap extends StatefulWidget {
  final NaverMapViewOptions options;
  final bool forceGesture;

  /*
    --- Listener ---
  */
  final void Function(NaverMapController controller)? onMapReady;
  final void Function(NPoint point, NLatLng latLng)? onMapTapped;
  final void Function(NSymbol symbol)? onSymbolTapped;
  final void Function(NCameraUpdateReason reason, bool animated)? onCameraChange;
  final void Function()? onCameraIdle;
  final void Function(NSelectedIndoor? selectedIndoor)? onSelectedIndoorChanged;

  const NaverMap({
    Key? key,
    this.options = const NaverMapViewOptions(),
    this.forceGesture = false,
    this.onMapReady,
    this.onMapTapped,
    this.onSymbolTapped,
    this.onCameraChange,
    this.onCameraIdle,
    this.onSelectedIndoorChanged,
  }) : super(key: key);

  @override
  State<NaverMap> createState() => _NaverMapState();
}

class _NaverMapState extends State<NaverMap> with _NaverMapControlHandler {
  late final MethodChannel methodChannel;
  late final NaverMapController controller;
  late NaverMapViewOptions nowViewOptions;
  final mapSdk = NaverMapSdk.instance;

  @override
  void initState() {
    nowViewOptions = widget.options;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(mapSdk._isInitialized);

    final payload = widget.options.toNPayload();

    if (nowViewOptions != widget.options) {
      print("update options");
      nowViewOptions = widget.options;
      controller._updateOptions(widget.options);
    }

    return _PlatformViewCreator.createPlatformView(
      viewType: NChannel.naverMapNativeView.str,
      gestureRecognizers: _createGestureRecognizers(widget.forceGesture),
      creationParams: payload,
      onPlatformViewCreated: _onPlatformViewCreated,
      androidSdkVersion: mapSdk._androidSdkVersion,
    );
  }

  void _onPlatformViewCreated(int id) {
    methodChannel = NChannel.naverMapNativeView.createChannel(id);
    controller = NaverMapController.createController(methodChannel, viewId: id);
    methodChannel.setMethodCallHandler(handle);
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
  void onSymbolTapped(NSymbol symbol) => widget.onSymbolTapped?.call(symbol);

  @override
  void onCameraChange(NCameraUpdateReason reason, bool animated) =>
      widget.onCameraChange?.call(reason, animated);

  @override
  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) =>
      widget.onSelectedIndoorChanged?.call(selectedIndoor);

  @override
  void onCameraIdle() => widget.onCameraIdle?.call();
}
