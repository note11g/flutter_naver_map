package dev.note11.flutter_naver_map.flutter_naver_map.model.map

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList

internal data class NLayerGroups(val groups: List<String>) {

    fun useWithEnableAndDisableGroups(func: (enableGroups: List<String>, disableGroups: List<String>) -> Unit) {
        val disableGroups = ALL_LAYER_GROUPS.groups - groups.toSet()
        func(groups, disableGroups)
    }

    companion object {
        fun fromRawList(rawList: Any): NLayerGroups = NLayerGroups(rawList.asList { it.toString() })

        private const val building: String = "building"
        private const val traffic: String = "ctt"
        private const val transit: String = "transit"
        private const val bicycle: String = "bike"
        private const val mountain: String = "mountain"
        private const val cadastral: String = "landparcel"

        private val ALL_LAYER_GROUPS: NLayerGroups = NLayerGroups(
            listOf(building, traffic, transit, bicycle, mountain, cadastral)
        )
    }
}
