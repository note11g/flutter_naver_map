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
            NOverlayImageMode.FILE -> OverlayImage.fromPath(path)
            NOverlayImageMode.TEMP -> makeOverlayImageWithTempPath(path)
            NOverlayImageMode.ASSET -> FlutterNaverMapPlugin.getAssets(path).let { assetPath ->
                OverlayImage.fromAsset(assetPath)
            }
        }

    // 파일 이름이 SHA-256 해시이므로, 파일 이름으로 대조해도 상관없음.
    private fun makeOverlayImageWithTempPath(path: String): OverlayImage =
        path.split("/").last().let { fileName ->
            overlayImageMap[fileName] ?: OverlayImage.fromPath(path)
                .also { img -> overlayImageMap[fileName] = img }
        }

    fun toMap(): Map<String, Any> = mapOf("path" to path, "mode" to mode.toString())

    companion object {
        fun fromMap(args: Any): NOverlayImage = args.asMap().let {
            NOverlayImage(
                path = it["path"]!!.toString(),
                mode = NOverlayImageMode.fromString(it["mode"]!!.toString()),
            )
        }

        private val overlayImageMap = mutableMapOf<String, OverlayImage>()
    }
}