import SwiftFaissC

public protocol BaseIndex {
    var indexPointer: IndexPointer { get }

    var d: Int { get }
    var isTrained: Bool { get }
    var count: Int { get }
    var metricType: MetricType { get }
    var verbose: Bool { get set }

    func add(_ xs: [[Float]]) throws
    func add(_ xs: [[Float]], ids: [Int]) throws
    func train(_ xs: [[Float]]) throws
    func reconstruct(_ key: Int) throws -> [Float]
    func reset() throws
    func search(_ xs: [[Float]], k: Int) throws -> (distances: [[Float]], labels: [[Int]])
    func saveToFile(_ fileName: String) throws
    func clone() throws -> Index
}

extension BaseIndex {
    public var d: Int {
        Int(faiss_Index_d(indexPointer.pointer))
    }

    public var isTrained: Bool {
        faiss_Index_is_trained(indexPointer.pointer) != 0
    }

    public var count: Int {
        Int(faiss_Index_ntotal(indexPointer.pointer))
    }

    public var metricType: MetricType {
        MetricType(faiss_Index_metric_type(indexPointer.pointer))
    }

    public var verbose: Bool {
        get {
            faiss_Index_verbose(indexPointer.pointer) != 0
        }
        set {
            faiss_Index_set_verbose(indexPointer.pointer, newValue ? 1 : 0)
        }
    }

    public func add(_ xs: [[Float]]) throws {
        try IndexError.check(
            faiss_Index_add(indexPointer.pointer, Int64(xs.count), xs.flatMap { $0 })
        )
    }

    public func add(_ xs: [[Float]], ids: [Int]) throws {
        precondition(xs.count == ids.count)
        try IndexError.check(
            faiss_Index_add_with_ids(
                indexPointer.pointer,
                Int64(xs.count),
                xs.flatMap { $0 },
                ids.map { Int64($0) }
            )
        )
    }

    public func train(_ xs: [[Float]]) throws {
        try IndexError.check(
            faiss_Index_train(indexPointer.pointer, Int64(xs.count), xs.flatMap { $0 })
        )
    }

    public func reconstruct(_ key: Int) throws -> [Float] {
        let recons = UnsafeMutablePointer<Float>.allocate(capacity: d)
        defer { recons.deallocate() }
        try IndexError.check(
            faiss_Index_reconstruct(indexPointer.pointer, Int64(key), recons)
        )
        return Array(UnsafeBufferPointer(start: recons, count: d))
    }

    public func reset() throws {
        try IndexError.check(
            faiss_Index_reset(indexPointer.pointer)
        )
    }

    public func search(_ xs: [[Float]], k: Int) throws -> (distances: [[Float]], labels: [[Int]]) {
        let k = min(k, count)
        let n = xs.count
        let capacity = n * k
        let distances = UnsafeMutablePointer<Float>.allocate(capacity: capacity)
        defer { distances.deallocate() }
        let labels = UnsafeMutablePointer<Int64>.allocate(capacity: capacity)
        defer { labels.deallocate() }
        try IndexError.check(
            faiss_Index_search(
                indexPointer.pointer,
                Int64(n),
                xs.flatMap { $0 },
                Int64(k),
                distances,
                labels
            )
        )
        return (
            distances: stride(from: 0, to: capacity, by: k).map {
                Array(UnsafeBufferPointer(start: distances.advanced(by: $0), count: k))
            },
            labels: stride(from: 0, to: capacity, by: k).map {
                Array(UnsafeBufferPointer(start: labels.advanced(by: $0), count: k)).map { Int($0) }
            }
        )
    }

    public func saveToFile(_ fileName: String) throws {
        try IndexError.check(
            faiss_write_index_fname(indexPointer.pointer, fileName)
        )
    }

    public func clone() throws -> Index {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_clone_index(indexPointer.pointer, indexPtr)
        )
        return Index(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
