part of flutter_naver_map;

class _PolygonOverlayUpdate {
  Set<PolygonOverlay?>? polygonToAdd;
  Set<String>? idToRemove;
  Set<PolygonOverlay?>? polygonToChange;

  _PolygonOverlayUpdate.from(
      Set<PolygonOverlay>? previous, Set<PolygonOverlay>? current) {
    previous ??= Set.identity();
    current ??= Set.identity();

    final Map<String, PolygonOverlay> prevPolygon = _keyByPolygonId(previous);
    final Map<String, PolygonOverlay> currentPolygon = _keyByPolygonId(current);

    final Set<String> prevPolygonIds = prevPolygon.keys.toSet();
    final Set<String> currentPolygonIds = currentPolygon.keys.toSet();

    PolygonOverlay? idToCurrentPolygon(String id) => currentPolygon[id];

    final Set<String> _polygonIdToRemove =
        prevPolygonIds.difference(currentPolygonIds);

    bool hasChanged(PolygonOverlay? current) =>
        current != prevPolygon[current!.polygonOverlayId];

    final Set<PolygonOverlay?> _polygonToChange = currentPolygonIds
        .intersection(prevPolygonIds)
        .map(idToCurrentPolygon)
        .where(hasChanged)
        .toSet();

    final Set<PolygonOverlay?> _polygonToAdd = currentPolygonIds
        .difference(prevPolygonIds)
        .map(idToCurrentPolygon)
        .toSet();

    polygonToAdd = _polygonToAdd;
    idToRemove = _polygonIdToRemove;
    polygonToChange = _polygonToChange;
  }

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('polygonToAdd', _serializePolygonSet(polygonToAdd));
    addIfNonNull('polygonToChange', _serializePolygonSet(polygonToChange));
    addIfNonNull(
        'polygonToRemove', idToRemove!.map((e) => e.toString()).toList());
    return updateMap;
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is _PolygonOverlayUpdate
        ? setEquals(polygonToAdd, other.polygonToAdd) &&
            setEquals(polygonToChange, other.polygonToChange) &&
            setEquals(idToRemove, other.idToRemove)
        : false;
  }

  @override
  int get hashCode => hashValues(polygonToAdd, polygonToChange, idToRemove);

  @override
  String toString() {
    return '_PolygonOverlayUpdates{polygonToAdd: $polygonToAdd, '
        'polygonIdsToRemove: $idToRemove, '
        'polygonToChange: $polygonToChange}';
  }
}
