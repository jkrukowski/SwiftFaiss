import SwiftFaissC

public final class ITQTransform: BaseVectorTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_ITQTransform_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(dIn: Int, dOut: Int, doPca: Bool) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_ITQTransform_new_with(
                indexPtr,
                Int32(dIn),
                Int32(dOut),
                doPca ? 1 : 0
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var doPca: Bool {
        faiss_ITQTransform_do_pca(indexPointer.pointer) != 0
    }
}
