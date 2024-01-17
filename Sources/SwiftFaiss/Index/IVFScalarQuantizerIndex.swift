import SwiftFaissC

public class IVFScalarQuantizerIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer
    // we keep a reference to the quantizer to prevent it from being deallocated
    private let quantizer: (any BaseIndex)?

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexIVFScalarQuantizer_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer, quantizer: (any BaseIndex)?) {
        self.indexPointer = indexPointer
        self.quantizer = quantizer
    }

    static func from(_ indexPointer: IndexPointer) -> IVFScalarQuantizerIndex? {
        faiss_IndexIVFScalarQuantizer_cast(indexPointer.pointer) == nil ?
            nil : IVFScalarQuantizerIndex(indexPointer: indexPointer, quantizer: nil)
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
        self.init(indexPointer: IndexPointer(indexPtr.pointee!), quantizer: quantizer)
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
