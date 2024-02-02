import ArgumentParser
import Logging
import SwiftFaiss

private let logger = Logger(label: "ClusteringExample")

struct ClusteringExample: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "clustering",
        abstract: "Example of clustering"
    )

    mutating func run() async throws {
        let embeddings = matrix(rows: 100, columns: 8)
        logger.info("Loaded \(embeddings.count) embeddings")

        let centroids = try kMeansClustering(embeddings, d: 8, k: 2)
        logger.info("Centroids: \(centroids)")
    }
}
