import SwiftFaissC

public final class OPQMatrixTransform: BaseLinearTransform {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_OPQMatrix_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(d: Int, m: Int, d2: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_OPQMatrix_new_with(
                indexPtr,
                Int32(d),
                Int32(m),
                Int32(d2)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var niter: Int {
        get {
            Int(faiss_OPQMatrix_niter(indexPointer.pointer))
        }
        set {
            faiss_OPQMatrix_set_niter(indexPointer.pointer, Int32(newValue))
        }
    }

    public var niterPQ: Int {
        get {
            Int(faiss_OPQMatrix_niter_pq(indexPointer.pointer))
        }
        set {
            faiss_OPQMatrix_set_niter_pq(indexPointer.pointer, Int32(newValue))
        }
    }
}
