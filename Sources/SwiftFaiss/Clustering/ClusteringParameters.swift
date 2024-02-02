import SwiftFaissC

public struct ClusteringParameters {
    var faissClusteringParameters: FaissClusteringParameters

    public init() {
        var faissClusteringParameters = FaissClusteringParameters()
        withUnsafeMutablePointer(to: &faissClusteringParameters) { pointer in
            faiss_ClusteringParameters_init(pointer)
        }
        self.faissClusteringParameters = faissClusteringParameters
    }

    public init(
        niter: Int,
        nredo: Int,
        isVerbose: Bool,
        isSpherical: Bool,
        shouldRoundCentroidsToInt: Bool,
        shouldUpdateIndex: Bool,
        shouldFrozeCentroids: Bool,
        minPointsPerCentroid: Int,
        maxPointsPerCentroid: Int,
        seed: Int,
        decodeBlockSize: Int
    ) {
        faissClusteringParameters = FaissClusteringParameters(
            niter: Int32(niter),
            nredo: Int32(nredo),
            verbose: isVerbose ? 1 : 0,
            spherical: isSpherical ? 1 : 0,
            int_centroids: shouldRoundCentroidsToInt ? 1 : 0,
            update_index: shouldUpdateIndex ? 1 : 0,
            frozen_centroids: shouldFrozeCentroids ? 1 : 0,
            min_points_per_centroid: Int32(minPointsPerCentroid),
            max_points_per_centroid: Int32(maxPointsPerCentroid),
            seed: Int32(seed),
            decode_block_size: decodeBlockSize
        )
    }

    public var niter: Int {
        get { Int(faissClusteringParameters.niter) }
        set { faissClusteringParameters.niter = Int32(newValue) }
    }

    public var nredo: Int {
        get { Int(faissClusteringParameters.nredo) }
        set { faissClusteringParameters.nredo = Int32(newValue) }
    }

    public var isVerbose: Bool {
        get { faissClusteringParameters.verbose != 0 }
        set { faissClusteringParameters.verbose = newValue ? 1 : 0 }
    }

    public var isSpherical: Bool {
        get { faissClusteringParameters.spherical != 0 }
        set { faissClusteringParameters.spherical = newValue ? 1 : 0 }
    }

    public var shouldRoundCentroidsToInt: Bool {
        get { faissClusteringParameters.int_centroids != 0 }
        set { faissClusteringParameters.int_centroids = newValue ? 1 : 0 }
    }

    public var shouldUpdateIndex: Bool {
        get { faissClusteringParameters.update_index != 0 }
        set { faissClusteringParameters.update_index = newValue ? 1 : 0 }
    }

    public var shouldFrozeCentroids: Bool {
        get { faissClusteringParameters.frozen_centroids != 0 }
        set { faissClusteringParameters.frozen_centroids = newValue ? 1 : 0 }
    }

    public var minPointsPerCentroid: Int {
        get { Int(faissClusteringParameters.min_points_per_centroid) }
        set { faissClusteringParameters.min_points_per_centroid = Int32(newValue) }
    }

    public var maxPointsPerCentroid: Int {
        get { Int(faissClusteringParameters.max_points_per_centroid) }
        set { faissClusteringParameters.max_points_per_centroid = Int32(newValue) }
    }

    public var seed: Int {
        get { Int(faissClusteringParameters.seed) }
        set { faissClusteringParameters.seed = Int32(newValue) }
    }

    public var decodeBlockSize: Int {
        get { Int(faissClusteringParameters.decode_block_size) }
        set { faissClusteringParameters.decode_block_size = newValue }
    }
}
