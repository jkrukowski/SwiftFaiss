import ArgumentParser
import Foundation
import SwiftFaiss

@main
struct SwiftFaissCLI: AsyncParsableCommand {
    mutating func run() async throws {
        let index = try Index(d: 4, metricType: .l2, description: "Flat")
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [1, 2, 3, 4]
        ])
        print(index.isTrained, index.count)
        let result = try index.search([[1, 2, 3, 4]], k: 100)
        print(result.distances, result.labels)
        try print(index.reconstruct(Int(result.labels[0][0])))
    }
}
