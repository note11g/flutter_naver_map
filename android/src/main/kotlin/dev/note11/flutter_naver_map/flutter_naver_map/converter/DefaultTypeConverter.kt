package dev.note11.flutter_naver_map.flutter_naver_map.converter

internal object DefaultTypeConverter {
    fun Any.asBoolean(): Boolean = this as Boolean
    fun Any.asDouble(): Double = if (this is Int) toDouble() else this as Double
    fun Any.asFloat(): Float = if (this is Double) toFloat() else this as Float
    fun Any.asInt(): Int = if (this is Long) toInt() else this as Int
    fun Any.asLong(): Long = if (this is Int) toLong() else this as Long

    @Suppress("UNCHECKED_CAST")
    fun Any.asMap(): Map<String, Any> = this as Map<String, Any>

    @Suppress("UNCHECKED_CAST")
    fun Any.asNullableMap(): Map<String, Any?> = this as Map<String, Any?>

    @Suppress("UNCHECKED_CAST")
    fun Any.asStringMap(): Map<String, String> = this as Map<String, String>

    @Suppress("UNCHECKED_CAST")
    fun Any.asObjectKeyMap(): Map<Any, Any> = this as Map<Any, Any>

    @Suppress("UNCHECKED_CAST")
    fun <T> Any.asList(elementCaster: ((Any) -> T)? = null): List<T> =
        if (elementCaster == null) this as List<T>
        else (this as List<Any>).map(elementCaster)
}