import SwiftFaissC

public final class AnyClustering: BaseClustering {
    public internal(set) var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_Clustering_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    public convenience init(d: Int, k: Int) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_Clustering_new(
                indexPtr,
                Int32(d),
                Int32(k)
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    public convenience init(d: Int, k: Int, clusteringParameters: ClusteringParameters) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try withUnsafePointer(to: clusteringParameters.faissClusteringParameters) { pointer in
            try IndexError.check(
                faiss_Clustering_new_with_params(
                    indexPtr,
                    Int32(d),
                    Int32(k),
                    pointer
                )
            )
        }
        self.init(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}

/// Simplified interface for k-means clustering.
///
/// - `xs`: training set
/// - `d`: dimension of the data
/// - `k`: number of output centroids
public func kMeansClustering(
    _ xs: [[Float]],
    d: Int,
    k: Int
) throws -> [[Float]] {
    let clustering = try AnyClustering(d: d, k: k)
    let index = try FlatIndex(d: d, metricType: .l2)
    try clustering.train(xs, index: index)
    return clustering.centroids()
}
