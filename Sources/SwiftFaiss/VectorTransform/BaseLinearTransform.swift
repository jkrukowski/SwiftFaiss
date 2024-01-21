import SwiftFaissC

public protocol BaseLinearTransform: BaseVectorTransform {
    var indexPointer: IndexPointer { get }
    var isOrthonormal: Bool { get }
    var haveBias: Bool { get }

    func makeOrthonormal()
    func transformTranspose(_ xs: [[Float]]) -> [[Float]]
}

extension BaseLinearTransform {
    public var isOrthonormal: Bool {
        faiss_LinearTransform_is_orthonormal(indexPointer.pointer) != 0
    }

    public var haveBias: Bool {
        faiss_LinearTransform_have_bias(indexPointer.pointer) != 0
    }

    public func makeOrthonormal() {
        faiss_LinearTransform_set_is_orthonormal(indexPointer.pointer)
    }

    public func transformTranspose(_ xs: [[Float]]) -> [[Float]] {
        let n = xs.count
        let capacity = n * dOut
        let resultPointer = UnsafeMutablePointer<Float>.allocate(capacity: capacity)
        defer { resultPointer.deallocate() }
        faiss_LinearTransform_transform_transpose(
            indexPointer.pointer,
            Int64(n),
            xs.flatMap { $0 },
            resultPointer
        )
        return stride(from: 0, to: capacity, by: dOut).map {
            Array(UnsafeBufferPointer(start: resultPointer.advanced(by: $0), count: dOut))
        }
    }
}
