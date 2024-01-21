import SwiftFaissC

public final class RemapDimensionsTransform: BaseVectorTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_RemapDimensionsTransform_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(dIn: Int, dOut: Int, uniform: Bool) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_RemapDimensionsTransform_new_with(
                indexPtr,
                Int32(dIn),
                Int32(dOut),
                uniform ? 1 : 0
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
