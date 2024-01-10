import SwiftFaissC

public struct IndexError: Error {
    public let resultCode: Int32
    public let message: String

    public init(resultCode: Int32, message: String) {
        self.resultCode = resultCode
        self.message = message
    }

    public init?(_ resultCode: Int32) {
        guard resultCode != 0 else {
            return nil
        }
        self.init(
            resultCode: resultCode,
            message: String(cString: faiss_get_last_error())
        )
    }

    public static func check(_ resultCode: Int32) throws {
        if let error = IndexError(resultCode) {
            throw error
        }
    }
}
