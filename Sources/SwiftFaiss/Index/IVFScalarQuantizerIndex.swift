import SwiftFaissC

public class IFVScalarQuantizerIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexIVFScalarQuantizer_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func from(_ indexPointer: IndexPointer) -> IFVScalarQuantizerIndex? {
        faiss_IndexIVFScalarQuantizer_cast(indexPointer.pointer) == nil ? nil : IFVScalarQuantizerIndex(indexPointer: indexPointer)
    }

    public convenience init(
        quantizer: any BaseIndex,
        quantizerType: QuantizerType,
        d: Int,
        nlist: Int,
        metricType: MetricType,
        encodeResidual: Bool
    ) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexIVFScalarQuantizer_new_with_metric(
                indexPtr,
                quantizer.indexPointer.pointer,
                d,
                nlist,
                quantizerType.faissQuantizerType,
                metricType.faissMetricType,
                encodeResidual ? 1 : 0
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public var nprobe: Int {
        get {
            Int(faiss_IndexIVFScalarQuantizer_nprobe(indexPointer.pointer))
        }
        set {
            faiss_IndexIVFScalarQuantizer_set_nprobe(indexPointer.pointer, newValue)
        }
    }

    public var nlist: Int {
        Int(faiss_IndexIVFScalarQuantizer_nlist(indexPointer.pointer))
    }
}
