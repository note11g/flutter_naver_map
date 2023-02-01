part of flutter_naver_map;

mixin _NaverMapControlHandler {
  void onMapReady();

  void onMapTapped(NPoint point, NLatLng latLng);

  void onSymbolTapped(NSymbol symbol);

  void onCameraChange(NCameraUpdateReason reason, bool animated);

  void onCameraIdle();

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor);

  Future<dynamic> handle(MethodCall call)  async {
    switch (call.method) {
      case "onMapReady":
        onMapReady();
        break;
      case "onMapTapped":
        final args = call.arguments;
        onMapTapped(
          NPoint._fromJson(args["nPoint"]),
          NLatLng._fromJson(args["latLng"]),
        );
        break;
      case "onSymbolTapped":
        onSymbolTapped(NSymbol._fromJson(call.arguments));
        break;
      case "onCameraChange":
        final args = call.arguments;
        onCameraChange(
          NCameraUpdateReason._fromJson(call.arguments["reason"]),
          args["animated"],
        );
        break;
      case "onCameraIdle":
        onCameraIdle();
        break;
      case "onSelectedIndoorChanged":
        final selectedIndoor = call.arguments != null
            ? NSelectedIndoor._fromJson(call.arguments)
            : null;
        onSelectedIndoorChanged(selectedIndoor);
        break;
    }
  }
}
