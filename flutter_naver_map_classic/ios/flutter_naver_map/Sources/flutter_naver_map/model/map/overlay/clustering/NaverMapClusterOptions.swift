internal struct NaverMapClusterOptions {
    let enableZoomRange: NRange<Int>
    let animationDuration: Int
    let mergeStrategy: NClusterMergeStrategy
    
    static func fromMessageable(_ v: Any) -> NaverMapClusterOptions {
        let d = asDict(v)
        return NaverMapClusterOptions(
            enableZoomRange: NRange.fromMessageableWithExactType(args: d["enableZoomRange"]!),
            animationDuration: asInt(d["animationDuration"]!),
            mergeStrategy: NClusterMergeStrategy.fromMessageable(d["mergeStrategy"]!)
        )
    }
}
