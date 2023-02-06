struct NSize {
    let width, height: CGFloat

    func use(widthFun: (CGFloat) -> Void, heightFun: (CGFloat) -> Void) {
        widthFun(width)
        heightFun(height)
    }

    func toDict() -> Dictionary<String, Any> {
        [
            "width": width,
            "height": height
        ]
    }

    // todo : fromDict 메서드 전부 Any로 a rg를 받고 있으므로, fromJson으로 바꿀것.
    // todo : android 도 같이 하기 (fromMap -> fromJson)
    // todo : toDict, toMap 도 바꾸기
    static func fromDict(_ args: Any) -> NSize {
        let d = asDict(args, valueCaster: asCGFloat)
        return NSize(width: d["width"]!, height: d["height"]!)
    }
}