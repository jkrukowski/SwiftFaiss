import SwiftFaissC

public final class ITQMatrixTransform: BaseLinearTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_ITQMatrix_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(d: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_ITQMatrix_new_with(
                indexPtr,
                Int32(d)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
