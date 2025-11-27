internal struct NLocale {
    let languageCode: String
    let countryCode: String?

    var localeStr: String {
        if (countryCode != nil && countryCode?.isEmpty == false) {
            return "\(languageCode)-\(countryCode!)"
        } else {
            return languageCode
        }
    }

    static func fromMessageable(_ args: Any) -> NLocale? {
        let d = asDict(args)
        let languageCode: String = asString(d["languageCode"]!)
        if languageCode == "sys" {
            return nil
        }
        return NLocale(
                languageCode: languageCode,
                countryCode: castOrNull(d["countryCode"], caster: asString)
        )
    }
}
