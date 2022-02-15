part of flutter_naver_map;

class _CircleOverlayUpdate {
  Set<CircleOverlay?>? circlesToAdd;
  Set<String>? circleIdsToRemove;
  Set<CircleOverlay?>? circlesToChange;

  _CircleOverlayUpdate.from(
      Set<CircleOverlay>? previous, Set<CircleOverlay>? current) {
    previous ??= Set<CircleOverlay>.identity();
    current ??= Set<CircleOverlay>.identity();

    final Map<String, CircleOverlay> previousCircles = _keyByCircleId(previous);
    final Map<String, CircleOverlay> currentCircles = _keyByCircleId(current);

    final Set<String> prevCircleIds = previousCircles.keys.toSet();
    final Set<String> currentCirclesIds = currentCircles.keys.toSet();

    CircleOverlay? idToCurrentCircle(String id) => currentCircles[id];

    final Set<String> _circleIdsToRemove =
        prevCircleIds.difference(currentCirclesIds);

    final Set<CircleOverlay?> _circlesToAdd = currentCirclesIds
        .difference(prevCircleIds)
        .map(idToCurrentCircle)
        .toSet();

    bool hasChanged(CircleOverlay? current) =>
        current != previousCircles[current!.overlayId];

    final Set<CircleOverlay?> _circlesToChange = currentCirclesIds
        .intersection(prevCircleIds)
        .map(idToCurrentCircle)
        .where(hasChanged)
        .toSet();

    circlesToAdd = _circlesToAdd;
    circleIdsToRemove = _circleIdsToRemove;
    circlesToChange = _circlesToChange;
  }

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('circlesToAdd', _serializeCircleSet(circlesToAdd));
    addIfNonNull('circlesToChange', _serializeCircleSet(circlesToChange));
    addIfNonNull('circleIdsToRemove',
        circleIdsToRemove!.map((e) => e.toString()).toList());
    return updateMap;
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is _CircleOverlayUpdate
        ? setEquals(circlesToAdd, other.circlesToAdd) &&
            setEquals(circlesToChange, other.circlesToChange) &&
            setEquals(circleIdsToRemove, other.circleIdsToRemove)
        : false;
  }

  @override
  int get hashCode =>
      hashValues(circlesToAdd, circlesToChange, circleIdsToRemove);

  @override
  String toString() {
    return '_CircleOverlayUpdates{circlesToAdd: $circlesToAdd, '
        'circleIdsToRemove: $circleIdsToRemove, '
        'circlesToChange: $circlesToChange}';
  }
}
