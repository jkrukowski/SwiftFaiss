import SwiftFaissC

public func loadFromFile(_ fileName: String, ioFlag: IOFlag = .readOnly) throws -> Index {
    let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
    defer { indexPtr.deallocate() }
    try IndexError.check(
        faiss_read_index_fname(fileName, ioFlag.faissIOFlag, indexPtr)
    )
    return Index(indexPointer: IndexPointer(indexPtr.pointee!))
}
