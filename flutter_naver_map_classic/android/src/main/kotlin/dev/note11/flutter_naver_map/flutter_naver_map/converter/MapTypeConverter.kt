package dev.note11.flutter_naver_map.flutter_naver_map.converter

import android.view.Gravity
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.*
import com.naver.maps.map.indoor.IndoorLevel
import com.naver.maps.map.indoor.IndoorRegion
import com.naver.maps.map.indoor.IndoorSelection
import com.naver.maps.map.indoor.IndoorZone
import com.naver.maps.map.overlay.Align
import com.naver.maps.map.overlay.PolylineOverlay.LineCap
import com.naver.maps.map.overlay.PolylineOverlay.LineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap

internal object MapTypeConverter {
    /*
      --- Objects ---
    */

    fun Any.asLatLng(): LatLng = asMap().let { map ->
        LatLng(map["lat"] as Double, map["lng"] as Double)
    }

    fun LatLng.toMessageable(): Map<String, Any> = mapOf(
        "lat" to latitude,
        "lng" to longitude
    )

    fun Any.asLatLngBounds(): LatLngBounds = asMap().let { map ->
        LatLngBounds(
            map["southWest"]!!.asLatLng(),
            map["northEast"]!!.asLatLng()
        )
    }

    fun LatLngBounds.toMessageable(): Map<String, Any> = mapOf(
        "southWest" to southWest.toMessageable(),
        "northEast" to northEast.toMessageable()
    )

    fun Any.asCameraPosition(): CameraPosition = asMap().let { map ->
        CameraPosition(
            map["target"]!!.asLatLng(),
            map["zoom"]!!.asDouble(),
            map["tilt"]!!.asDouble(),
            map["bearing"]!!.asDouble()
        )
    }

    fun CameraPosition.toMessageable(): Map<String, Any> = mapOf(
        "target" to target.toMessageable(),
        "zoom" to zoom,
        "tilt" to tilt,
        "bearing" to bearing
    )

    fun IndoorSelection.toMessageable(): Map<String, Any> = mapOf(
        "levelIndex" to levelIndex,
        "zoneIndex" to zoneIndex,
        "region" to region.toMessageable()
    )

    fun IndoorRegion.toMessageable(): Map<String, Any> = mapOf(
        "zones" to zones.map { zone -> zone.toMessageable() },
    )

    fun IndoorZone.toMessageable(): Map<String, Any> = mapOf(
        "id" to zoneId,
        "defaultLevelIndex" to defultLevelIndex,
        "levels" to levels.map { level -> level.toMessageable() },
    )

    fun IndoorLevel.toMessageable(): Map<String, Any> = mapOf(
        "name" to name,
        "hashCode" to hashCode(),
    )

    /*
    --- Enums ---
     */

    fun Any.asCameraAnimation(): CameraAnimation = when (this) {
        "easing" -> CameraAnimation.Easing
        "fly" -> CameraAnimation.Fly
        "linear" -> CameraAnimation.Linear
        else -> CameraAnimation.None
    }

    fun Any.asMapType(): NaverMap.MapType = when (this) {
        "basic" -> NaverMap.MapType.Basic
        "hybrid" -> NaverMap.MapType.Hybrid
        "naviHybrid" -> NaverMap.MapType.NaviHybrid
        "navi" -> NaverMap.MapType.Navi
        "satellite" -> NaverMap.MapType.Satellite
        "terrain" -> NaverMap.MapType.Terrain
        else -> NaverMap.MapType.None
    }

    fun Any.asLocationTrackingMode(): LocationTrackingMode = when (this) {
        "face" -> LocationTrackingMode.Face
        "follow" -> LocationTrackingMode.Follow
        "noFollow" -> LocationTrackingMode.NoFollow
        else -> LocationTrackingMode.None
    }

    fun LocationTrackingMode.toMessageableString(): String = when (this) {
        LocationTrackingMode.Face -> "face"
        LocationTrackingMode.Follow -> "follow"
        LocationTrackingMode.NoFollow -> "noFollow"
        LocationTrackingMode.None -> "none"
    }

    fun Any.asAlign(): Align = when (this) {
        "center" -> Align.Center
        "left" -> Align.Left
        "right" -> Align.Right
        "top" -> Align.Top
        "bottom" -> Align.Bottom
        "topLeft" -> Align.TopLeft
        "topRight" -> Align.TopRight
        "bottomLeft" -> Align.BottomLeft
        "bottomRight" -> Align.BottomRight
        else -> throw IllegalArgumentException("Invalid align value")
    }

    fun Align.toMessageableString(): String = when (this) {
        Align.Center -> "center"
        Align.Left -> "left"
        Align.Right -> "right"
        Align.Top -> "top"
        Align.Bottom -> "bottom"
        Align.TopLeft -> "topLeft"
        Align.TopRight -> "topRight"
        Align.BottomLeft -> "bottomLeft"
        Align.BottomRight -> "bottomRight"
    }

    fun Any.asLogoAlign(): Int = when (this) {
        "leftBottom" -> Gravity.LEFT or Gravity.BOTTOM
        "rightBottom" -> Gravity.RIGHT or Gravity.BOTTOM
        "leftTop" -> Gravity.LEFT or Gravity.TOP
        "rightTop" -> Gravity.RIGHT or Gravity.TOP
        else -> throw IllegalArgumentException("Invalid logo align value")
    }

    fun Any.asLineCap(): LineCap = when (this) {
        "butt" -> LineCap.Butt
        "round" -> LineCap.Round
        "square" -> LineCap.Square
        else -> throw IllegalArgumentException("Invalid line cap value")
    }

    fun LineCap.toMessageableString(): String = when (this) {
        LineCap.Butt -> "butt"
        LineCap.Round -> "round"
        LineCap.Square -> "square"
    }

    fun Any.asLineJoin(): LineJoin = when (this) {
        "bevel" -> LineJoin.Bevel
        "miter" -> LineJoin.Miter
        "round" -> LineJoin.Round
        else -> throw IllegalArgumentException("Invalid line join value")
    }

    fun LineJoin.toMessageableString(): String = when (this) {
        LineJoin.Bevel -> "bevel"
        LineJoin.Miter -> "miter"
        LineJoin.Round -> "round"
    }
}