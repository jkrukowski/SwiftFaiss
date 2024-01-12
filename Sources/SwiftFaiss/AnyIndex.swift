import SwiftFaissC

public class AnyIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_Index_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    /// Create new index
    ///
    /// - Parameters:
    ///  - d: The dimension of the vectors to index.
    ///  - metricType: The metric type to use.
    ///  - description: https://github.com/facebookresearch/faiss/wiki/The-index-factory
    public convenience init(d: Int, metricType: MetricType, description: String) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_index_factory(
                indexPtr,
                Int32(d),
                description,
                metricType.faissMetricType
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var flat: FlatIndex? {
        FlatIndex.from(indexPointer)
    }

    public var IVF: IVFIndex? {
        IVFIndex.from(indexPointer)
    }

    public var IVFFlat: IVFFlatIndex? {
        IVFFlatIndex.from(indexPointer)
    }

    public var LSH: LSHIndex? {
        LSHIndex.from(indexPointer)
    }
}
