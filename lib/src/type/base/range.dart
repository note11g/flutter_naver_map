part of "../../../flutter_naver_map.dart";

/// 네이버 맵에서 특정 범위를 나타내는 객체입니다.
///
/// 주로, 줌 레벨의 범위를 나타낼 때 사용됩니다.
///
/// e.g.
///
/// ( 8 < range <= 17 ) => `NMapRange(8, 17, includeMin: false)`
///
/// ( 0 < range < 21 ) => `NMapRange(0, 21, includeMin: false, includeMax: false)`
///
/// ( range <= 7 ) => `NMapRange(null, 7)`
///
@immutable
class NRange<T extends num> with NMessageableWithMap {
  final T? min;
  final T? max;
  final bool includeMin;
  final bool includeMax;

  const NRange(
    this.min,
    this.max, {
    this.includeMin = true,
    this.includeMax = true,
  }) : assert(min == null || max == null || min <= max);

  /// 값이 범위 내에 있는지 확인합니다.
  bool contains(num value) {
    if (min == null && max == null) return true;

    final lowerBound = min == null
        ? true
        : includeMin
            ? value >= min!
            : value > min!;
    final upperBound = max == null
        ? true
        : includeMax
            ? value <= max!
            : value < max!;

    return lowerBound && upperBound;
  }

  /// 다른 범위 객체가 현재 범위 내에 완전히 포함되는지 확인합니다.
  bool containsRange(NRange other) {
    final bool minCompare;
    if (min == null) {
      minCompare = true;
    } else if (other.min == null) {
      minCompare = false;
    } else {
      minCompare = includeMin ? other.min! >= min! : other.min! > min!;
    }

    final bool maxCompare;
    if (max == null) {
      maxCompare = true;
    } else if (other.max == null) {
      maxCompare = false;
    } else {
      maxCompare = includeMax ? other.max! <= max! : other.max! < max!;
    }

    return minCompare && maxCompare;
  }

  @experimental
  NRange<T>? intersection(NRange other) {
    final bool isDisjoint =
        (min != null && other.max != null && min! > other.max!) ||
            (min != null &&
                other.max != null &&
                min! == other.max! &&
                !(includeMin && other.includeMax)) ||
            (max != null && other.min != null && max! < other.min!) ||
            (max != null &&
                other.min != null &&
                max! == other.min! &&
                !(includeMax && other.includeMin));

    if (isDisjoint) {
      return null;
    }

    final T? newMin = ((min == null || other.min == null)
        ? min ?? other.min
        : math.max(min!, other.min!)) as T?;
    final T? newMax = ((max == null || other.max == null)
        ? max ?? other.max
        : math.min(max!, other.max!)) as T?;

    final bool newIncludeMin = newMin == min ? includeMin : other.includeMin;
    final bool newIncludeMax = newMax == max ? includeMax : other.includeMax;

    return NRange(newMin, newMax,
        includeMin: newIncludeMin, includeMax: newIncludeMax);
  }

  static const mapZoomRange = NInclusiveRange(0, 21);

  @override
  NPayload toNPayload() => NPayload.make({
        "min": min,
        "max": max,
        "inMin": includeMin,
        "inMax": includeMax,
      });
}

/// 네이버 맵에서 특정 범위를 나타내는 객체입니다.
///
/// min <= Range <= max 를 나타냅니다.
/// NInclusiveRange<int>일 경우, range는 정수로 판별됩니다.
///
/// e.g.) NInclusiveRange(1, 15)일 경우, 허용되는 값: 1<= N < 16
/// (N이 실수일 경우, N.toInt() 된 값으로 판단되기 때문입니다.)
///
/// 주로, 줌 레벨의 범위를 나타낼 때 사용됩니다.
class NInclusiveRange<T extends num> extends NRange<T> {
  const NInclusiveRange(super.min, super.max)
      : super(includeMin: true, includeMax: true);
}
