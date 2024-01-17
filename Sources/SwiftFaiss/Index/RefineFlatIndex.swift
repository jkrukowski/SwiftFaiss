import SwiftFaissC

public final class RefineFlatIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer
    // we keep a reference to the subIndex to prevent it from being deallocated
    private let baseIndex: (any BaseIndex)?

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexRefineFlat_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer, baseIndex: (any BaseIndex)?) {
        self.indexPointer = indexPointer
        self.baseIndex = baseIndex
    }

    static func from(_ indexPointer: IndexPointer) -> RefineFlatIndex? {
        faiss_IndexRefineFlat_cast(indexPointer.pointer) == nil ? nil : RefineFlatIndex(indexPointer: indexPointer, baseIndex: nil)
    }

    public convenience init(baseIndex: any BaseIndex) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexRefineFlat_new(
                indexPtr,
                baseIndex.indexPointer.pointer
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!), baseIndex: baseIndex)
    }

    public var kFactor: Float {
        get {
            faiss_IndexRefineFlat_k_factor(indexPointer.pointer)
        }
        set {
            faiss_IndexRefineFlat_set_k_factor(indexPointer.pointer, newValue)
        }
    }
}
