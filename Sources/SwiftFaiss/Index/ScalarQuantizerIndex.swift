import SwiftFaissC

public class ScalarQuantizerIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexScalarQuantizer_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func from(_ indexPointer: IndexPointer) -> ScalarQuantizerIndex? {
        faiss_IndexScalarQuantizer_cast(indexPointer.pointer) == nil ? nil : ScalarQuantizerIndex(indexPointer: indexPointer)
    }

    public convenience init(d: Int, quantizerType: QuantizerType, metricType: MetricType) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexScalarQuantizer_new_with(
                indexPtr,
                Int64(d),
                quantizerType.faissQuantizerType,
                metricType.faissMetricType
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
