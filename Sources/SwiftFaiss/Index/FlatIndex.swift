import SwiftFaissC

public final class FlatIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexFlat_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func from(_ indexPointer: IndexPointer) -> FlatIndex? {
        faiss_IndexFlat_cast(indexPointer.pointer) == nil ? nil : FlatIndex(indexPointer: indexPointer)
    }

    public convenience init(d: Int, metricType: MetricType) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexFlat_new_with(
                indexPtr,
                Int64(d),
                metricType.faissMetricType
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public func xb() -> [[Float]] {
        let result = UnsafeMutablePointer<UnsafeMutablePointer<Float>?>.allocate(capacity: 1)
        defer { result.deallocate() }
        let size = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        defer { size.deallocate() }
        faiss_IndexFlat_xb(indexPointer.pointer, result, size)
        return stride(from: 0, to: size.pointee, by: d).map {
            Array(UnsafeBufferPointer(start: result.pointee!.advanced(by: $0), count: d))
        }
    }
}
