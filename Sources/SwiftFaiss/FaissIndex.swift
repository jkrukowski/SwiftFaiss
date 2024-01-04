import SwiftFaissC

open class FaissIndex {
    let indexPtr: UnsafeMutablePointer<OpaquePointer?>
    var index: OpaquePointer {
        indexPtr.pointee!
    }

    init(indexPtr: UnsafeMutablePointer<OpaquePointer?>) {
        self.indexPtr = indexPtr
    }

    public init(d: Int, metricType: MetricType, description: String) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        try FaissIndexError.check(
            faiss_index_factory(
                indexPtr,
                Int32(d),
                description,
                metricType.faissMetricType
            )
        )
        self.indexPtr = indexPtr
    }

    public static func flatL2(_ d: Int) throws -> FaissIndex {
        try FaissIndex(d: d, metricType: .l2, description: "Flat")
    }

    open var d: Int {
        Int(faiss_Index_d(index))
    }

    open var isTrained: Bool {
        faiss_Index_is_trained(index) != 0
    }

    open var count: Int {
        Int(faiss_Index_ntotal(index))
    }

    open var metricType: MetricType {
        MetricType(faiss_Index_metric_type(index))
    }

    open var nprobe: Int {
        get {
            Int(faiss_IndexIVF_nprobe(index))
        }
        set {
            faiss_IndexIVF_set_nprobe(index, newValue)
        }
    }

    open func makeDirectMap() throws {
        try FaissIndexError.check(
            faiss_IndexIVF_make_direct_map(index, 1)
        )
    }

    open func clearDirectMap() throws {
        try FaissIndexError.check(
            faiss_IndexIVF_make_direct_map(index, 0)
        )
    }

    open func add(_ xs: [Float]) throws {
        try FaissIndexError.check(
            faiss_Index_add(index, 1, xs)
        )
    }

    open func train(_ xs: [Float]) throws {
        try FaissIndexError.check(
            faiss_Index_train(index, 1, xs)
        )
    }

    open func reconstruct(_ key: Int) throws -> [Float] {
        let recons = UnsafeMutablePointer<Float>.allocate(capacity: d)
        defer { recons.deallocate() }
        try FaissIndexError.check(
            faiss_Index_reconstruct(index, Int64(key), recons)
        )
        return Array(UnsafeBufferPointer(start: recons, count: d))
    }

    open func reset() throws {
        try FaissIndexError.check(
            faiss_Index_reset(index)
        )
    }

    open func search(_ xs: [Float], k: Int) throws -> (distances: [Float], labels: [Int64]) {
        let k = min(k, count)
        let distances = UnsafeMutablePointer<Float>.allocate(capacity: d * k)
        defer { distances.deallocate() }
        let labels = UnsafeMutablePointer<Int64>.allocate(capacity: d * k)
        defer { labels.deallocate() }
        try FaissIndexError.check(
            faiss_Index_search(
                index,
                Int64(d),
                xs,
                Int64(k),
                distances,
                labels
            )
        )
        return (
            distances: Array(UnsafeBufferPointer(start: distances, count: k)),
            labels: Array(UnsafeBufferPointer(start: labels, count: k))
        )
    }

    open func saveToFile(_ fileName: String) throws {
        try FaissIndexError.check(
            faiss_write_index_fname(index, fileName)
        )
    }

    public static func loadFromFile(_ fileName: String) throws -> FaissIndex {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        try FaissIndexError.check(
            faiss_read_index_fname(fileName, FAISS_IO_FLAG_READ_ONLY, indexPtr)
        )
        return FaissIndex(indexPtr: indexPtr)
    }

    deinit {
        faiss_Index_free(index)
        indexPtr.deallocate()
    }
}
