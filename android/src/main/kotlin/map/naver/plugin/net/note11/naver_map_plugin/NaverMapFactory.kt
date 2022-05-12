package map.naver.plugin.net.note11.naver_map_plugin

import android.app.Activity
import map.naver.plugin.net.note11.naver_map_plugin.Convert.carveMapOptions
import io.flutter.plugin.common.BinaryMessenger
import android.content.Context
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import java.util.concurrent.atomic.AtomicInteger

class NaverMapFactory(
    private val activityState: AtomicInteger,
    private val binaryMessenger: BinaryMessenger,
    private val activity: Activity
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, i: Int, args: Any?): PlatformView {
        val params = args as Map<String, Any>
        val builder = NaverMapBuilder()
        if (params.containsKey("initialCameraPosition")) {
            val initPosition = params["initialCameraPosition"] as Map<String, Any?>?
            if (initPosition != null) builder.setInitialCameraPosition(initPosition)
        }
        if (params.containsKey("options")) {
            (params["options"] as Map<String, Any>?)?.let { options ->
                if (options.containsKey("useSurface")) {
                    val useSurface = options["useSurface"] as Boolean
                    builder.setViewType(useSurface)
                }
                carveMapOptions(builder, options)
            }
        }
        if (params.containsKey("markers")) {
            builder.setInitialMarkers(params["markers"] as List<Any?>?)
        }
        if (params.containsKey("paths")) {
            builder.setInitialPaths(params["paths"] as List<Any?>?)
        }
        if (params.containsKey("circles")) {
            builder.setInitialCircles(params["circles"] as List<Any?>?)
        }
        if (params.containsKey("polygons")) {
            builder.setInitialPolygon(params["polygons"] as List<Any?>?)
        }
        return builder.build(
            i,
            context,
            activityState,
            binaryMessenger,
            activity
        )
    }
}