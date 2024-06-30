package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay

import android.graphics.BitmapFactory
import com.naver.maps.map.overlay.OverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.FlutterNaverMapPlugin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayImageMode
import java.util.ArrayList

internal data class NOverlayImage(
    val path: String,
    val data: ByteArray,
    val mode: NOverlayImageMode,
) {
    fun applyToOverlay(setImgFunc: (OverlayImage) -> Unit) = setImgFunc.invoke(overlayImage)

    private val overlayImage: OverlayImage
        get() = when (mode) {
            NOverlayImageMode.FILE, NOverlayImageMode.TEMP, NOverlayImageMode.WIDGET -> makeOverlayImageWithPath()
            NOverlayImageMode.ASSET -> makeOverlayImageWithAssetPath()
            NOverlayImageMode.DATA -> makeOverlayImageWithData()
        }


    private fun makeOverlayImageWithPath(): OverlayImage = OverlayImage.fromPath(path)

    private fun makeOverlayImageWithAssetPath(): OverlayImage {
        val assetPath = FlutterNaverMapPlugin.getAssets(path)
        return OverlayImage.fromAsset(assetPath)
    }

    private fun makeOverlayImageWithData(): OverlayImage {
        val bitmap = BitmapFactory.decodeByteArray(data, 0, data.size)
        return OverlayImage.fromBitmap(bitmap)
    }

    fun toMessageable(): Map<String, Any> = mapOf(
        "path" to path,
        "data" to data,
        "mode" to mode.toString()
    )

    companion object {
        fun fromMessageable(args: Any): NOverlayImage = args.asMap().let {
            NOverlayImage(
                path = it["path"]!!.toString(),
                data = (it["data"]!! as ArrayList<Byte>).toByteArray(),
                mode = NOverlayImageMode.fromString(it["mode"]!!.toString()),
            )
        }

        val none = NOverlayImage(path = "", data = byteArrayOf(),  mode = NOverlayImageMode.TEMP)
    }
}