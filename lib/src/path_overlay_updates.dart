part of flutter_naver_map;

/// [PathOverlay] update events to be applied to the [NaverMap].
///
/// Used in [NaverMapController] when the map is updated.
class _PathOverlayUpdates {
  Set<PathOverlay?>? pathOverlaysToAddOrUpdate;
  Set<PathOverlayId>? pathOverlayIdsToRemove;

  _PathOverlayUpdates.from(
      Set<PathOverlay>? previous, Set<PathOverlay>? current) {
    previous ??= Set<PathOverlay>.identity();
    current ??= Set<PathOverlay>.identity();

    final Map<PathOverlayId, PathOverlay> previousPathOverlays =
        _keyByPathOverlayId(previous);
    final Map<PathOverlayId, PathOverlay> currentPathOverlays =
        _keyByPathOverlayId(current);

    final Set<PathOverlayId> prevPathOverlayIds =
        previousPathOverlays.keys.toSet();
    final Set<PathOverlayId> currentPathOverlayIds =
        currentPathOverlays.keys.toSet();

    PathOverlay? idToCurrentPolylineOverlay(PathOverlayId id) {
      return currentPathOverlays[id];
    }

    final Set<PathOverlayId> _pathOverlayIdsToRemove =
        prevPathOverlayIds.difference(currentPathOverlayIds);

    final Set<PathOverlay?> _pathOverlaysToAddOrModify =
        currentPathOverlayIds.map(idToCurrentPolylineOverlay).toSet();

    pathOverlaysToAddOrUpdate = _pathOverlaysToAddOrModify;
    pathOverlayIdsToRemove = _pathOverlayIdsToRemove;
  }

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('pathToAddOrUpdate',
        _serializePathOverlaySet(pathOverlaysToAddOrUpdate));
    addIfNonNull(
        'pathIdsToRemove',
        pathOverlayIdsToRemove!
            .map<dynamic>((PathOverlayId m) => m.value)
            .toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is _PathOverlayUpdates &&
        setEquals(pathOverlaysToAddOrUpdate, other.pathOverlaysToAddOrUpdate) &&
        setEquals(pathOverlayIdsToRemove, other.pathOverlayIdsToRemove);
  }

  @override
  int get hashCode =>
      hashValues(pathOverlaysToAddOrUpdate, pathOverlayIdsToRemove);

  @override
  String toString() {
    return '_PolylineUpdates{pathToAddOrUpdate: $pathOverlaysToAddOrUpdate, '
        'pathIdsToRemove: $pathOverlayIdsToRemove';
  }
}
