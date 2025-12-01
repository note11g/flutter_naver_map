internal struct NClusterMergeStrategy {
    let willMergedScreenDistance: Dictionary<NRange<Int>, Double>
    let maxMergeableScreenDistance: Double
    
    static func fromMessageable(_ v: Any) -> NClusterMergeStrategy {
        let d = asDict(v)
        return NClusterMergeStrategy(
            willMergedScreenDistance: asDictWithObjectKey(d["willMergedScreenDistance"]!,
            keyCaster: NRange<Int>.fromMessageableWithExactType, valueCaster: asDouble),
            maxMergeableScreenDistance: asDouble(d["maxMergeableScreenDistance"]!)
        )
    }
}
