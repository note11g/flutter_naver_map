import 'package:flutter_naver_map/flutter_naver_map.dart';

extension NLatLngExtension on NLatLng {
  String toShortString([int length = 5]) {
    return "${latitude.toStringAsFixed(length)}, ${longitude.toStringAsFixed(length)}";
  }
}
