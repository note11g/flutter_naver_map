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
            NOverlayImageMode.FILE, NOverlayImageMode.TEMP, NOverlayImageMode.WIDGET -> makeOverlayImageWithPath()
            NOverlayImageMode.ASSET -> makeOverlayImageWithAssetPath()
        }


    private fun makeOverlayImageWithPath(): OverlayImage = OverlayImage.fromPath(path)

    private fun makeOverlayImageWithAssetPath(): OverlayImage {
        val assetPath = FlutterNaverMapPlugin.getAssets(path)
        return OverlayImage.fromAsset(assetPath)
    }

    fun toMessageable(): Map<String, Any> = mapOf("path" to path, "mode" to mode.toString())

    companion object {
        fun fromMessageable(args: Any): NOverlayImage = args.asMap().let {
            NOverlayImage(
                path = it["path"]!!.toString(),
                mode = NOverlayImageMode.fromString(it["mode"]!!.toString()),
            )
        }

        val none = NOverlayImage(path = "", mode = NOverlayImageMode.TEMP)
    }
}