package map.naver.plugin.net.note11.naver_map_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import android.app.Application.ActivityLifecycleCallbacks
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import android.os.Bundle
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.concurrent.atomic.AtomicInteger

/** NaverMapPlugin  */
class NaverMapPlugin : FlutterPlugin, ActivityLifecycleCallbacks, ActivityAware {

    constructor()

    constructor(activity: Activity) {
        registrarActivityHashCode = activity.hashCode()
    }

    private val state = AtomicInteger(0)
    private var registrarActivityHashCode = 0
    private var pluginBinding: FlutterPluginBinding? = null
    private var activityPluginBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        pluginBinding = binding
    }

    // 플러그인 등록
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        registrarActivityHashCode = binding.activity.hashCode()
        binding.activity.application.registerActivityLifecycleCallbacks(this)
        pluginBinding
            ?.platformViewRegistry
            ?.registerViewFactory(
                "naver_map_plugin",
                NaverMapFactory(
                    state,
                    pluginBinding!!.binaryMessenger,
                    binding.activity
                )
            )
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding!!.activity.application.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        binding.activity.application.registerActivityLifecycleCallbacks(this)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding!!.activity.application.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        pluginBinding = null
    }

    // ========================= ActivityLifeCycleCallBack =============================
    override fun onActivityCreated(activity: Activity, bundle: Bundle?) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(CREATED)
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(STARTED)
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(RESUMED)
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(PAUSED)
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(STOPPED)
    }

    override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(SAVE_INSTANCE_STATE)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        activity.application.unregisterActivityLifecycleCallbacks(this)
        state.set(DESTROYED)
    }

    companion object {
        const val CREATED = 1
        const val STARTED = 2
        const val RESUMED = 3
        const val PAUSED = 4
        const val STOPPED = 5
        const val SAVE_INSTANCE_STATE = 6
        const val DESTROYED = 7

        // 플러그인 등록 (Legacy)
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) {
                // 백그라운드에서 플러그인을 등록하려고 시도할때 엑티비티는 존재하지 않습니다.
                // 이 플러그인이 포어그라운드에서만 돌아가기 때문에 백그라운드에서 등록하는 것을 막습니다.
                return
            }
            val plugin = NaverMapPlugin(registrar.activity())
            registrar.activity().application.registerActivityLifecycleCallbacks(plugin)
            // 라이프사이클 콜백
            registrar
                .platformViewRegistry()
                .registerViewFactory(
                    "naver_map_plugin",
                    NaverMapFactory(
                        plugin.state,
                        registrar.messenger(),
                        registrar.activity()
                    )
                )
        }
    }
}