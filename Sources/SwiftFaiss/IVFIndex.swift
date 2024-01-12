import SwiftFaissC

public final class IVFIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexIVF_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func from(_ indexPointer: IndexPointer) -> IVFIndex? {
        faiss_IndexIVF_cast(indexPointer.pointer) == nil ? nil : IVFIndex(indexPointer: indexPointer)
    }

    public var nprobe: Int {
        get {
            Int(faiss_IndexIVF_nprobe(indexPointer.pointer))
        }
        set {
            faiss_IndexIVF_set_nprobe(indexPointer.pointer, newValue)
        }
    }

    public var nlist: Int {
        Int(faiss_IndexIVF_nlist(indexPointer.pointer))
    }

    public var imbalanceFactor: Double {
        faiss_IndexIVF_imbalance_factor(indexPointer.pointer)
    }

    public func makeDirectMap() throws {
        try IndexError.check(
            faiss_IndexIVF_make_direct_map(indexPointer.pointer, 1)
        )
    }

    public func clearDirectMap() throws {
        try IndexError.check(
            faiss_IndexIVF_make_direct_map(indexPointer.pointer, 0)
        )
    }
}
