import Foundation

public struct SearchResult: Hashable {
    public let distances: [[Float]]
    public let labels: [[Int]]

    public init(distances: [[Float]], labels: [[Int]]) {
        self.distances = distances
        self.labels = labels
    }
}
