internal extension  CGFloat {
    func orDefault(_ defaultValue: CGFloat, emptyFlag: Int = -1) -> CGFloat {
        isEqual(to: CGFloat(emptyFlag)) ? defaultValue : self
    }
}