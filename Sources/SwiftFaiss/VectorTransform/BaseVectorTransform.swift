import SwiftFaissC

public protocol BaseVectorTransform {
    var indexPointer: IndexPointer { get }
    var isTrained: Bool { get }
    var dIn: Int { get }
    var dOut: Int { get }

    func train(_ xs: [[Float]]) throws
    func apply(_ xs: [[Float]]) throws -> [[Float]]
    func reverseTransform(_ xs: [[Float]]) throws -> [[Float]]
}

extension BaseVectorTransform {
    public var isTrained: Bool {
        faiss_VectorTransform_is_trained(indexPointer.pointer) != 0
    }

    public var dIn: Int {
        Int(faiss_VectorTransform_d_in(indexPointer.pointer))
    }

    public var dOut: Int {
        Int(faiss_VectorTransform_d_out(indexPointer.pointer))
    }

    public func train(_ xs: [[Float]]) throws {
        try IndexError.check(
            faiss_VectorTransform_train(
                indexPointer.pointer,
                Int64(xs.count),
                xs.flatMap { $0 }
            )
        )
    }

    public func apply(_ xs: [[Float]]) throws -> [[Float]] {
        let n = xs.count
        let capacity = n * dOut
        let resultPointer = UnsafeMutablePointer<Float>.allocate(capacity: capacity)
        defer { resultPointer.deallocate() }
        faiss_VectorTransform_apply_noalloc(
            indexPointer.pointer,
            Int64(n),
            xs.flatMap { $0 },
            resultPointer
        )
        return stride(from: 0, to: capacity, by: dOut).map {
            Array(UnsafeBufferPointer(start: resultPointer.advanced(by: $0), count: dOut))
        }
    }

    public func reverseTransform(_ xs: [[Float]]) throws -> [[Float]] {
        let n = xs.count
        let capacity = n * dIn
        let resultPointer = UnsafeMutablePointer<Float>.allocate(capacity: capacity)
        defer { resultPointer.deallocate() }
        faiss_VectorTransform_reverse_transform(
            indexPointer.pointer,
            Int64(n),
            xs.flatMap { $0 },
            resultPointer
        )
        return stride(from: 0, to: capacity, by: dIn).map {
            Array(UnsafeBufferPointer(start: resultPointer.advanced(by: $0), count: dIn))
        }
    }
}
