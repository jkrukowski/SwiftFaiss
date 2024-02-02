@testable import SwiftFaiss
import XCTest

final class ClusteringTests: XCTestCase {
    func testKMeansEmptyShouldThrow() throws {
        XCTAssertThrowsError(
            try kMeansClustering([], d: 8, k: 2)
        )
    }

    func testKMeansNonEmptyShouldReturnResult() throws {
        let d = 8
        let k = 2
        let xs = matrix(rows: 100, columns: d)
        let result = try kMeansClustering(xs, d: d, k: k)
        XCTAssertEqual(result.count, k)
        XCTAssertTrue(result.allSatisfy { $0.count == d })
    }
}
