import SwiftFaissC

public class Index: BaseIndex {
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

    public var IVF: IndexIVF? {
        IndexIVF.from(pointer: indexPointer)
    }

    public var IVFFlat: IndexIVFFlat? {
        IndexIVFFlat.from(pointer: indexPointer)
    }

    public var LSH: IndexLSH? {
        IndexLSH.from(pointer: indexPointer)
    }
}
