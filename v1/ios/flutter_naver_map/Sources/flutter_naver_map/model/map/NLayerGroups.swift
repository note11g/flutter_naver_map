import NMapsMap

internal struct NLayerGroups {
    let groups: Set<String>

    func useWithEnableAndDisableGroups(fun: (_ enableGroups: Set<String>, _ disableGroups: Set<String>) -> Void) {
        let disableGroups = NLayerGroups.allLayerGroups.groups.subtracting(groups)

        fun(groups, disableGroups)
    }

    static func fromRawArr(rawArr: Any) -> NLayerGroups {
        NLayerGroups(groups: Set(asArr(rawArr, elementCaster: asString)))
    }

    private static let building: String = "building"
    private static let traffic: String = "ctt"
    private static let transit: String = "transit"
    private static let bicycle: String = "bike"
    private static let mountain: String = "mountain"
    private static let cadastral: String = "landparcel"

    private static let allLayerGroups: NLayerGroups = NLayerGroups(groups: [
        building, traffic, transit, bicycle, mountain, cadastral
    ])
}