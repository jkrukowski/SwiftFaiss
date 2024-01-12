import SwiftFaissC

public enum IOFlag {
    case mmap
    case readOnly

    var faissIOFlag: Int32 {
        switch self {
        case .mmap:
            FAISS_IO_FLAG_MMAP
        case .readOnly:
            FAISS_IO_FLAG_READ_ONLY
        }
    }
}

public func loadFromFile(_ fileName: String, ioFlag: IOFlag = .readOnly) throws -> AnyIndex {
    let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
    defer { indexPtr.deallocate() }
    try IndexError.check(
        faiss_read_index_fname(fileName, ioFlag.faissIOFlag, indexPtr)
    )
    return AnyIndex(indexPointer: IndexPointer(indexPtr.pointee!))
}
