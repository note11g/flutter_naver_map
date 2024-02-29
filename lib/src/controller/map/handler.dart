part of "../../../flutter_naver_map.dart";

mixin _NaverMapControlHandler {
  void onMapReady();

  void onMapTapped(NPoint point, NLatLng latLng);

  void onSymbolTapped(NSymbolInfo symbol);

  @Deprecated("use `onCameraChangeWithCameraPosition` instead")
  void onCameraChange(NCameraUpdateReason reason, bool animated);

  void onCameraChangeWithCameraPosition(
      NCameraUpdateReason reason, bool animated, NCameraPosition position);

  void onCameraIdle();

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor);

  Future<dynamic> handle(MethodCall call) async {
    switch (call.method) {
      case "onMapReady":
        onMapReady();
        break;
      case "onMapTapped":
        final args = call.arguments;
        onMapTapped(
          NPoint._fromMessageable(args["nPoint"]),
          NLatLng._fromMessageable(args["latLng"]),
        );
        break;
      case "onSymbolTapped":
        onSymbolTapped(NSymbolInfo._fromMessageable(call.arguments));
        break;
      case "onCameraChange":
        final args = call.arguments;
        onCameraChangeWithCameraPosition(
            NCameraUpdateReason._fromMessageable(args["reason"]),
            args["animated"],
            NCameraPosition._fromMessageable(args["position"]));
        break;
      case "onCameraIdle":
        onCameraIdle();
        break;
      case "onSelectedIndoorChanged":
        final selectedIndoor = call.arguments != null
            ? NSelectedIndoor._fromMessageable(call.arguments)
            : null;
        onSelectedIndoorChanged(selectedIndoor);
        break;
    }
  }
}
