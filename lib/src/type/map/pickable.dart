part of flutter_naver_map;

abstract class Pickable {
  static Pickable _fromJson(dynamic json,
      {required _NOverlayController overlayController}) {
    final signature = json["signature"] as String;
    if (signature == "symbol") {
      return NSymbol._fromJson(json);
    } else if (signature == "overlay") {
      final info = NOverlayInfo._fromJson(json["info"]);
      late final NOverlay overlay;
      switch (info.type) {
        case NOverlayType.marker:
          overlay = NMarker._fromJson(json);
          break;
        case NOverlayType.infoWindow:
          overlay = NInfoWindow._fromJson(json);
          break;
        case NOverlayType.circleOverlay:
          overlay = NCircleOverlay._fromJson(json);
          break;
        case NOverlayType.groundOverlay:
          overlay = NGroundOverlay._fromJson(json);
          break;
        case NOverlayType.polygonOverlay:
          overlay = NPolygonOverlay._fromJson(json);
          break;
        case NOverlayType.polylineOverlay:
          overlay = NPolylineOverlay._fromJson(json);
          break;
        case NOverlayType.pathOverlay:
          overlay = NPathOverlay._fromJson(json);
          break;
        case NOverlayType.multiPartPathOverlay:
          overlay = NMultiPartPathOverlay._fromJson(json);
          break;
        case NOverlayType.arrowHeadPathOverlay:
          overlay = NArrowHeadPathOverlay._fromJson(json);
          break;
        case NOverlayType.locationOverlay:
          overlay = overlayController.locationOverlay;
          break;
      }
      return overlay.._addedOnMap(overlayController, addFunc: false);
    } else {
      throw NUnknownTypeCastException(unknownValue: json);
    }
  }
}
