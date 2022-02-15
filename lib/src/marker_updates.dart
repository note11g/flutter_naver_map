part of flutter_naver_map;

/// build 시에 새로운 마커들은 [NaverMap] 에 적용된다.
///
/// [NaverMapController] 에서 마커를 업데이트할 떄 사용된다.
class _MarkerUpdates {
  /// 업데이트 이전의 [Marker]와 새로운 [Marker]를 이용해서
  /// [_MarkerUpdates] 객체를 생성한다.
  _MarkerUpdates.from(Set<Marker>? previous, Set<Marker>? current) {
    previous ??= Set<Marker>.identity();
    current ??= Set<Marker>.identity();

    final Map<String, Marker> previousMarkers = _keyByMarkerId(previous);
    final Map<String, Marker> currentMarkers = _keyByMarkerId(current);

    final Set<String> prevMarkerIds = previousMarkers.keys.toSet();
    final Set<String> currentMarkerIds = currentMarkers.keys.toSet();

    Marker? idToCurrentMarker(String id) {
      return currentMarkers[id];
    }

    final Set<String> _markerIdsToRemove =
        prevMarkerIds.difference(currentMarkerIds);

    final Set<Marker?> _markersToAdd = currentMarkerIds
        .difference(prevMarkerIds)
        .map(idToCurrentMarker)
        .toSet();

    /// 새로운 마커의 아이디가 기존의 것과 다른 경우 true 리턴.
    bool hasChanged(Marker? current) {
      final Marker? previous = previousMarkers[current!.markerId];
      return current != previous;
    }

    final Set<Marker?> _markersToChange = currentMarkerIds
        .intersection(prevMarkerIds)
        .map(idToCurrentMarker)
        .where(hasChanged)
        .toSet();

    markersToAdd = _markersToAdd;
    markerIdsToRemove = _markerIdsToRemove;
    markersToChange = _markersToChange;
  }

  Set<Marker?>? markersToAdd;
  Set<String>? markerIdsToRemove;
  Set<Marker?>? markersToChange;

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('markersToAdd', _serializeMarkerSet(markersToAdd));
    addIfNonNull('markersToChange', _serializeMarkerSet(markersToChange));
    addIfNonNull('markerIdsToRemove',
        markerIdsToRemove!.map<dynamic>((String m) => m.toString()).toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is _MarkerUpdates &&
        setEquals(markersToAdd, other.markersToAdd) &&
        setEquals(markerIdsToRemove, other.markerIdsToRemove) &&
        setEquals(markersToChange, other.markersToChange);
  }

  @override
  int get hashCode =>
      hashValues(markersToAdd, markerIdsToRemove, markersToChange);

  @override
  String toString() {
    return '_MarkerUpdates{markersToAdd: $markersToAdd, '
        'markerIdsToRemove: $markerIdsToRemove, '
        'markersToChange: $markersToChange}';
  }
}
