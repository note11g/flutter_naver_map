package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.clustering

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asLong
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NRange

internal data class NaverMapClusterOptions(
    val enableZoomRange: NRange<Int>,
    val animationDuration: Long,
    val mergeStrategy: NClusterMergeStrategy,
) {
    companion object {
        fun fromMessageable(args: Any): NaverMapClusterOptions = args.asMap().let { map ->
            NaverMapClusterOptions(
                enableZoomRange = NRange.fromMessageableWithExactType(map["enableZoomRange"]!!),
                animationDuration = map["animationDuration"]!!.asLong(),
                mergeStrategy = NClusterMergeStrategy.fromMessageable(map["mergeStrategy"]!!),
            )
        }
    }
}
