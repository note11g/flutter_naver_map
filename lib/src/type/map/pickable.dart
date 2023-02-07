part of flutter_naver_map;

abstract class Pickable {
  static Pickable _fromMessageable(dynamic m,
      {required _NOverlayController overlayController}) {
    final signature = m["signature"] as String;
    if (signature == "symbol") {
      return NSymbol._fromMessageable(m);
    } else if (signature == "overlay") {
      final info = NOverlayInfo._fromMessageable(m["info"]);
      late final NOverlay overlay;
      switch (info.type) {
        case NOverlayType.marker:
          overlay = NMarker._fromMessageable(m);
          break;
        case NOverlayType.infoWindow:
          overlay = NInfoWindow._fromMessageable(m);
          break;
        case NOverlayType.circleOverlay:
          overlay = NCircleOverlay._fromMessageable(m);
          break;
        case NOverlayType.groundOverlay:
          overlay = NGroundOverlay._fromMessageable(m);
          break;
        case NOverlayType.polygonOverlay:
          overlay = NPolygonOverlay._fromMessageable(m);
          break;
        case NOverlayType.polylineOverlay:
          overlay = NPolylineOverlay._fromMessageable(m);
          break;
        case NOverlayType.pathOverlay:
          overlay = NPathOverlay._fromMessageable(m);
          break;
        case NOverlayType.multipartPathOverlay:
          overlay = NMultipartPathOverlay._fromMessageable(m);
          break;
        case NOverlayType.arrowheadPathOverlay:
          overlay = NArrowheadPathOverlay._fromMessageable(m);
          break;
        case NOverlayType.locationOverlay:
          overlay = overlayController.locationOverlay;
          break;
      }
      return overlay.._addedOnMap(overlayController, addFunc: false);
    } else {
      throw NUnknownTypeCastException(unknownValue: m);
    }
  }
}
