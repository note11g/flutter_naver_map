package dev.note11.flutter_naver_map.flutter_naver_map.model.base

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap

internal data class NRange<T : Number>(
    val min: T?,
    val max: T?,
    val includeMin: Boolean,
    val includeMax: Boolean,
) {
    fun isInRange(value: Number): Boolean {
        val minCheck = when {
            min == null -> true
            includeMin -> value.toDouble() >= min.toDouble()
            else -> value.toDouble() > min.toDouble()
        }

        val maxCheck = when {
            max == null -> true
            includeMax -> value.toDouble() <= max.toDouble()
            else -> value.toDouble() < max.toDouble()
        }

        return minCheck && maxCheck
    }

    companion object {
        fun fromMessageable(args: Any): NRange<out Number> = args.asMap().let { map ->
            val rawMin = map["min"]
            val rawMax = map["max"]
            val inMin = map["inMin"]!!.asBoolean()
            val inMax = map["inMax"]!!.asBoolean()

            when {
                rawMin is Int || rawMax is Int -> return NRange(
                    min = rawMin as Int?,
                    max = rawMax as Int?,
                    includeMin = inMin,
                    includeMax = inMax,
                )

                rawMin is Double || rawMax is Double -> return NRange(
                    min = rawMin as Double?,
                    max = rawMax as Double?,
                    includeMin = inMin,
                    includeMax = inMax,
                )

                else -> throw IllegalArgumentException("Invalid NRange type")
            }
        }

        inline fun <reified T : Number> fromMessageableWithExactType(args: Any): NRange<T> =
            args.asMap().let { map ->
                val rawMin = map["min"]
                val rawMax = map["max"]
                require(rawMin is T? && rawMax is T?)
                return NRange(
                    min = rawMin,
                    max = rawMax,
                    includeMin = map["inMin"]!!.asBoolean(),
                    includeMax = map["inMax"]!!.asBoolean(),
                )
            }
    }
}
