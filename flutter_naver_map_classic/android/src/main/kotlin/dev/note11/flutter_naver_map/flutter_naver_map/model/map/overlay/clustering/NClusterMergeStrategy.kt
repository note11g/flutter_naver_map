package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.clustering

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asObjectKeyMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NRange

internal data class NClusterMergeStrategy(
//    val mergeByEachTagEnableZoomRanges: Map<String, NRange<Int>>,
    val willMergedScreenDistance: Map<NRange<Int>, Double>,
    val maxMergeableScreenDistance: Double,
//    val minClusterChildCount: Int,
) {

    companion object {
        fun fromMessageable(args: Any): NClusterMergeStrategy = args.asMap().let { map ->
            NClusterMergeStrategy(
//                mergeByEachTagEnableZoomRanges = map["mergeByEachTagEnableZoomRanges"]!!.asMap()
//                    .mapValues { NRange.fromMessageableWithExactType(it.value) },
                willMergedScreenDistance = map["willMergedScreenDistance"]!!.asObjectKeyMap()
                    .mapKeys {
                        NRange.fromMessageableWithExactType<Int>(it.key)
                    }.mapValues { it.value.asDouble() },
                maxMergeableScreenDistance = map["maxMergeableScreenDistance"]!!.asDouble(),
//                minClusterChildCount = map["minClusterChildCount"]!!.asInt(),
            )
        }
    }
}