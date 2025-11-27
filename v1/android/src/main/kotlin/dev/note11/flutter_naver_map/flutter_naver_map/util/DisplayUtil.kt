package dev.note11.flutter_naver_map.flutter_naver_map.util

import android.content.res.Resources
import androidx.annotation.Px
import kotlin.math.roundToInt

internal object DisplayUtil {
    private val density: Float
        get() {
            val density = Resources.getSystem().displayMetrics.density
            if (density != 0.0F) return density
            else throw Exception("getDisplayDensity Failed")
        }

    @Px
    fun dpToPx(dp: Double): Int {
        return (dp * density).roundToInt()
    }

    @Px
    fun dpToPxF(dp: Double): Float {
        return (dp * density).toFloat()
    }

    fun pxToDp(@Px px: Int): Double {
        return px.toDouble() / density
    }

    fun pxToDp(@Px px: Float): Double {
        return px.toDouble() / density
    }
}