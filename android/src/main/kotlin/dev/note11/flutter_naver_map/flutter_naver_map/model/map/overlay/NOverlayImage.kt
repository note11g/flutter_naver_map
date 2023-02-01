package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay

import com.naver.maps.map.overlay.OverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.FlutterNaverMapPlugin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayImageMode

internal data class NOverlayImage(
    val path: String,
    val mode: NOverlayImageMode,
) {
    fun applyToOverlay(setImgFunc: (OverlayImage) -> Unit) = setImgFunc.invoke(overlayImage)

    private val overlayImage: OverlayImage
        get() = when (mode) {
            NOverlayImageMode.FILE -> makeOverlayImageWithPath()
            NOverlayImageMode.TEMP -> makeOverlayImageWithTempPath()
            NOverlayImageMode.ASSET -> makeOverlayImageWithAssetPath()
        }


    private fun makeOverlayImageWithPath(): OverlayImage =
        OverlayImage.fromPath(path).also(::saveOverlayImage)

    private fun makeOverlayImageWithTempPath(): OverlayImage =
        overlayImageMap[this] ?: OverlayImage.fromPath(path).also(::saveOverlayImage)

    private fun makeOverlayImageWithAssetPath(): OverlayImage {
        val assetPath = FlutterNaverMapPlugin.getAssets(path)
        return OverlayImage.fromAsset(assetPath).also(::saveOverlayImage)
    }

    private fun saveOverlayImage(overlayImage: OverlayImage) {
        overlayImageMap[this] = overlayImage
    }

    fun toMap(): Map<String, Any> = mapOf("path" to path, "mode" to mode.toString())

    companion object {
        fun fromMap(args: Any): NOverlayImage = args.asMap().let {
            NOverlayImage(
                path = it["path"]!!.toString(),
                mode = NOverlayImageMode.fromString(it["mode"]!!.toString()),
            )
        }

        private val overlayImageMap = mutableMapOf<NOverlayImage, OverlayImage>()

        fun fromOverlayImage(overlayImage: OverlayImage): NOverlayImage =
            overlayImageMap.entries.find { it.value == overlayImage }!!.key
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as NOverlayImage

        if (path != other.path) return false
        if (mode != other.mode) return false

        return true
    }

    override fun hashCode(): Int {
        var result = path.hashCode()
        result = 31 * result + mode.hashCode()
        return result
    }
}