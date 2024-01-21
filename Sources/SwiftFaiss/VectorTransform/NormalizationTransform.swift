import SwiftFaissC

public final class NormalizationTransform: BaseVectorTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_NormalizationTransform_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(d: Int, norm: Float) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_NormalizationTransform_new_with(
                indexPtr,
                Int32(d),
                norm
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var norm: Float {
        faiss_NormalizationTransform_norm(indexPointer.pointer)
    }
}
