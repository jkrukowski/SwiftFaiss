import SwiftFaissC

public final class RandomRotationMatrixTransform: BaseLinearTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_RandomRotationMatrix_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(dIn: Int, dOut: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_RandomRotationMatrix_new_with(
                indexPtr,
                Int32(dIn),
                Int32(dOut)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
