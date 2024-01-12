import ArgumentParser
import Foundation
import SwiftFaiss

@main
struct SwiftFaissCLI: AsyncParsableCommand {
    mutating func run() async throws {
        let index = try FlatIndex(d: 4, metricType: .l2)
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [1, 2, 3, 4]
        ])
        print(index.isTrained, index.count)
        let result = try index.searchRange([[1, 2, 3, 4], [1, 2, 3, 4]], radius: 10_000)
        print("Search result: \(result)")
        print("Current index data: \(index.xb())")
        try print("Removed \(index.removeIds([1, 2])) values")
        print("Index data after removal: \(index.xb())")
    }
}
