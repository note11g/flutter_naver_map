struct NFlutterException {
    let code: String
    let message: String?
    
    init(code: String, message: String?) {
        self.code = code
        self.message = message
    }
    
    init(error: Error) {
        self.code = error._code.description
        self.message = error.localizedDescription
    }
    
    func toMessageable() -> [String: Any?] {
        return [
            "code": code,
            "message": message
        ]
    }
}
