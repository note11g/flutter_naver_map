package dev.note11.flutter_naver_map.flutter_naver_map.util

import android.graphics.SurfaceTexture
import android.util.Log
import android.view.TextureView
import android.view.ViewGroup

internal object TextureSurfaceViewUtil {
    // check on this page: https://github.com/flutter/packages/commit/e393d452beaf4b216e2567bc2cee0225087f4662#diff-a5d65392fa8d540804d121990b51b05aa51e9a42dbbfc7e45ec4c4e181e3b872
    fun installInvalidator(mapView: ViewGroup) {
        val textureView = findTextureView(mapView)
        if (textureView == null) {
            Log.i("NaverMapView", "No TextureView found. Likely using the LEGACY renderer.")
            return
        }

        Log.i("NaverMapView", "Installing custom TextureView driven invalidator.")
        val internalListener = textureView.surfaceTextureListener
        textureView.surfaceTextureListener = object : TextureView.SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(
                surface: SurfaceTexture,
                width: Int,
                height: Int,
            ) {
                internalListener?.onSurfaceTextureAvailable(surface, width, height)
            }

            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
                return internalListener?.onSurfaceTextureDestroyed(surface) ?: true
            }

            override fun onSurfaceTextureSizeChanged(
                surface: SurfaceTexture, width: Int, height: Int,
            ) {
                internalListener?.onSurfaceTextureSizeChanged(surface, width, height)
            }

            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {
                internalListener?.onSurfaceTextureUpdated(surface)
                mapView.invalidate()
            }
        }
    }

    private fun findTextureView(group: ViewGroup): TextureView? {
        for (i in 0 until group.childCount) {
            when (val view = group.getChildAt(i)) {
                is TextureView -> return view
                is ViewGroup -> {
                    val r = findTextureView(view)
                    if (r != null) return r
                }
            }
        }
        return null
    }
}