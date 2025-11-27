package dev.note11.flutter_naver_map.flutter_naver_map

import android.app.Activity
import android.content.Context
import dev.note11.flutter_naver_map.flutter_naver_map.sdk.SdkInitializer
import dev.note11.flutter_naver_map.flutter_naver_map.util.location.NDefaultMyLocationTracker
import dev.note11.flutter_naver_map.flutter_naver_map.view.NaverMapViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

internal class FlutterNaverMapPlugin : FlutterPlugin, ActivityAware {
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var sdkInitializer: SdkInitializer
    private lateinit var defaultMyLocationTracker: NDefaultMyLocationTracker
    private val context: Context get() = pluginBinding.applicationContext

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        flutterAssets = flutterPluginBinding.flutterAssets
        initializeSdkChannel()
    }

    private fun initializeSdkChannel() {
        val sdkChannel = MethodChannel(pluginBinding.binaryMessenger, SDK_CHANNEL_NAME)
        sdkInitializer = SdkInitializer(context, sdkChannel)
    }

    private fun initializeDefaultMyLocationTracker(activity: Activity) {
        defaultMyLocationTracker =
            NDefaultMyLocationTracker(pluginBinding.binaryMessenger, activity)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity
        val naverMapViewFactory =
            NaverMapViewFactory(activity, pluginBinding.binaryMessenger)
        pluginBinding.platformViewRegistry.registerViewFactory(
            MAP_VIEW_TYPE_ID, naverMapViewFactory
        )
        initializeDefaultMyLocationTracker(activity)
    }

    override fun onDetachedFromActivityForConfigChanges() = Unit

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = Unit

    override fun onDetachedFromActivity() {
        sdkInitializer.dispose()
        if (::defaultMyLocationTracker.isInitialized) defaultMyLocationTracker.dispose()
    }

    companion object {
        private const val SDK_CHANNEL_NAME = "flutter_naver_map_sdk"
        private const val OVERLAY_CHANNEL_NAME = "flutter_naver_map_overlay"
        private const val MAP_VIEW_TYPE_ID = "flutter_naver_map_view"

        private const val SEPARATE_STRING = "#"

        internal fun createViewMethodChannelName(id: Int): String =
            "${MAP_VIEW_TYPE_ID}${SEPARATE_STRING}$id"

        internal fun createOverlayMethodChannelName(viewId: Int): String =
            "${OVERLAY_CHANNEL_NAME}${SEPARATE_STRING}$viewId"

        private lateinit var flutterAssets: FlutterAssets

        internal fun getAssets(path: String): String {
            return flutterAssets.getAssetFilePathByName(path)
        }
    }
}
