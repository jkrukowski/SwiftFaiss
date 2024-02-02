import SwiftFaissC

public protocol BaseClustering {
    var indexPointer: IndexPointer { get }
    var k: Int { get }
    var d: Int { get }
    var niter: Int { get }
    var nredo: Int { get }
    var isVerbose: Bool { get }
    var isSpherical: Bool { get }
    var shouldRoundCentroidsToInt: Bool { get }
    var shouldUpdateIndex: Bool { get }
    var shouldFrozeCentroids: Bool { get }
    var minPointsPerCentroid: Int { get }
    var maxPointsPerCentroid: Int { get }
    var seed: Int { get }
    var decodeBlockSize: Int { get }

    func train(_ xs: [[Float]], index: BaseIndex) throws
    func centroids() -> [[Float]]
}

extension BaseClustering {
    public var k: Int {
        Int(faiss_Clustering_k(indexPointer.pointer))
    }

    public var d: Int {
        Int(faiss_Clustering_d(indexPointer.pointer))
    }

    public var niter: Int {
        Int(faiss_Clustering_niter(indexPointer.pointer))
    }

    public var nredo: Int {
        Int(faiss_Clustering_nredo(indexPointer.pointer))
    }

    public var isVerbose: Bool {
        faiss_Clustering_verbose(indexPointer.pointer) != 0
    }

    public var isSpherical: Bool {
        faiss_Clustering_spherical(indexPointer.pointer) != 0
    }

    public var shouldRoundCentroidsToInt: Bool {
        faiss_Clustering_int_centroids(indexPointer.pointer) != 0
    }

    public var shouldUpdateIndex: Bool {
        faiss_Clustering_update_index(indexPointer.pointer) != 0
    }

    public var shouldFrozeCentroids: Bool {
        faiss_Clustering_frozen_centroids(indexPointer.pointer) != 0
    }

    public var minPointsPerCentroid: Int {
        Int(faiss_Clustering_min_points_per_centroid(indexPointer.pointer))
    }

    public var maxPointsPerCentroid: Int {
        Int(faiss_Clustering_max_points_per_centroid(indexPointer.pointer))
    }

    public var seed: Int {
        Int(faiss_Clustering_seed(indexPointer.pointer))
    }

    public var decodeBlockSize: Int {
        faiss_Clustering_decode_block_size(indexPointer.pointer)
    }

    public func train(_ xs: [[Float]], index: BaseIndex) throws {
        try IndexError.check(
            faiss_Clustering_train(
                indexPointer.pointer,
                Int64(xs.count),
                xs.flatMap { $0 },
                index.indexPointer.pointer
            )
        )
    }

    public func centroids() -> [[Float]] {
        let centroids = UnsafeMutablePointer<UnsafeMutablePointer<Float>?>.allocate(capacity: 1)
        defer { centroids.deallocate() }
        let size = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        defer { size.deallocate() }
        faiss_Clustering_centroids(
            indexPointer.pointer,
            centroids,
            size
        )
        var result = [[Float]]()
        result.reserveCapacity(k)
        for index in 0 ..< k {
            result.append(Array(UnsafeBufferPointer(start: centroids.pointee!.advanced(by: index * d), count: d)))
        }
        return result
    }
}
