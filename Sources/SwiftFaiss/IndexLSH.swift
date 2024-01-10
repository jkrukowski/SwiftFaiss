import SwiftFaissC

public final class IndexLSH: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexLSH_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func from(pointer: IndexPointer) -> IndexLSH? {
        faiss_IndexLSH_cast(pointer.pointer) == nil ? nil : IndexLSH(indexPointer: pointer)
    }

    public convenience init(d: Int, nbits: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexLSH_new(
                indexPtr,
                Int64(d),
                Int32(nbits)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public convenience init(d: Int, nbits: Int, rotateData: Int, trainThresholds: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexLSH_new_with_options(
                indexPtr,
                Int64(d),
                Int32(nbits),
                Int32(rotateData),
                Int32(trainThresholds)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
