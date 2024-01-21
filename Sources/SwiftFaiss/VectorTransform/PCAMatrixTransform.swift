import SwiftFaissC

public final class PCAMatrixTransform: BaseLinearTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_PCAMatrix_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(dIn: Int, dOut: Int, eigenPower: Float, randomRotation: Bool) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_PCAMatrix_new_with(
                indexPtr,
                Int32(dIn),
                Int32(dOut),
                eigenPower,
                randomRotation ? 1 : 0
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var eigenPower: Float {
        faiss_PCAMatrix_eigen_power(indexPointer.pointer)
    }

    public var randomRotation: Bool {
        faiss_PCAMatrix_random_rotation(indexPointer.pointer) != 0
    }
}
