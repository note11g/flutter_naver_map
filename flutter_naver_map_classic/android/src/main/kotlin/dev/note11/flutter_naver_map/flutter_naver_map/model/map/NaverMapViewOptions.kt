package dev.note11.flutter_naver_map.flutter_naver_map.model.map

import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions
import dev.note11.flutter_naver_map.flutter_naver_map.applier.ApplyUtil.applyOptions
import dev.note11.flutter_naver_map.flutter_naver_map.applier.option.NaverMapApplierImpl
import dev.note11.flutter_naver_map.flutter_naver_map.applier.option.NaverMapOptionApplierImpl
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean

internal data class NaverMapViewOptions(
    /**
     * NaverMapOptions.
     * if null, it's not first provide. (update with naverMap Object.)
     *  */
    private val _naverMapOptions: NaverMapOptions?,
    /*
     * 여기부터는
     *  1. NaverMapOptions 이 아닌 NaverMap 의 옵션들
     *  2. 또한, NaverMapApplier 에서도 적용할 수 없는 옵션들
     *  3. 코드 이외의 방식으로 변경¹되지 않는 옵션들
     * 을 작성합니다.
     * ¹ 코드 이외의 방식으로 변경되는 예시: [LocationTrackingMode : 사용자의 현위치 버튼 사용에 따라 변경될 수 있음]
     */
    val consumeSymbolTapEvents: Boolean,
) {
    // 사용시, null 이 아님을 보장합니다.
    val naverMapOptions: NaverMapOptions get() = _naverMapOptions!!

    companion object {
        // factory constructor
        fun fromMessageable(
            args: Map<String, Any?>,
            convertNaverMapOptions: Boolean = true,
        ): NaverMapViewOptions {
            val options = if (convertNaverMapOptions) naverMapOptionFromMessageable(args) else null
            val consumeSymbolTapEvents = args["consumeSymbolTapEvents"]!!.asBoolean()

            return NaverMapViewOptions(options, consumeSymbolTapEvents)
        }

        fun updateNaverMapFromMessageable(
            naverMap: NaverMap,
            args: Map<String, Any?>,
            customStyleCallback: NaverMap.OnCustomStyleLoadCallback? = null,
        ): NaverMapViewOptions {
            val applier = NaverMapApplierImpl(naverMap, customStyleCallback)
            applier.applyOptions(args)
            return fromMessageable(args, false)
        }

        private fun naverMapOptionFromMessageable(
            args: Map<String, Any?>,
        ): NaverMapOptions {
            val options = NaverMapOptions().apply {
                compassEnabled(false)
                zoomControlEnabled(false)
                scaleBarEnabled(false)
                logoClickEnabled(false)
                locationButtonEnabled(false)
            }

            val applier = NaverMapOptionApplierImpl(options)

            return applier.applyOptions(args).options
        }
    }
}
