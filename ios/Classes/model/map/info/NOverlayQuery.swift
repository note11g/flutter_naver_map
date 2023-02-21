internal struct NOverlayQuery {
    let info: NOverlayInfo
    let methodName: String

    var query: String {
        encode()
    }

    static func fromQuery(_ query: String) -> NOverlayQuery {
        decode(string: query)
    }

    // ----- Encode / Decode -----

    private func encode() -> String {
        [info.type.rawValue, info.id, methodName].joined(separator: NOverlayQuery.SEPARATOR)
    }

    private static func decode(string: String) -> NOverlayQuery {
        let split = string.components(separatedBy: NOverlayQuery.SEPARATOR)
        let type = split.first!
        let method = split.last!
        let id = split.dropFirst().dropLast().joined(separator: NOverlayQuery.SEPARATOR)
        return NOverlayQuery(
                info: NOverlayInfo(type: NOverlayType(rawValue: type)!, id: id),
                methodName: method
        )
    }

    private static let SEPARATOR = "\""
}