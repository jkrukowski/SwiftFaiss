import SwiftFaissC

public final class AnyIndex: BaseIndex {
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
}

extension AnyIndex {
    public static func PQ(d: Int, m: Int, nbit: Int = 8, metricType: MetricType) throws -> AnyIndex {
        try AnyIndex(d: d, metricType: metricType, description: "PQ\(m)x\(nbit)")
    }

    public static func IVFPQ(d: Int, m: Int, nbit: Int = 8, metricType: MetricType) throws -> AnyIndex {
        try AnyIndex(d: d, metricType: metricType, description: "PQ\(m)x\(nbit)")
    }
}

extension AnyIndex {
    public func toFlat() -> FlatIndex? {
        FlatIndex.from(indexPointer)
    }

    public func toIVF() -> IVFIndex? {
        IVFIndex.from(indexPointer)
    }

    public func toIVFFlat() -> IVFFlatIndex? {
        IVFFlatIndex.from(indexPointer)
    }

    public func toIVFScalarQuantizer() -> IVFScalarQuantizerIndex? {
        IVFScalarQuantizerIndex.from(indexPointer)
    }

    public func toLSH() -> LSHIndex? {
        LSHIndex.from(indexPointer)
    }

    public func toIDMap() -> IDMap? {
        IDMap.from(indexPointer)
    }

    public func toIDMap2() -> IDMap2? {
        IDMap2.from(indexPointer)
    }

    public func toRefineFlat() -> RefineFlatIndex? {
        RefineFlatIndex.from(indexPointer)
    }

    public func toScalarQuantizer() -> ScalarQuantizerIndex? {
        ScalarQuantizerIndex.from(indexPointer)
    }
}
