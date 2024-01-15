@testable import SwiftFaiss
import XCTest

final class RefineFlatIndexTests: XCTestCase {
    func testRefineFlatIndex() throws {
        let baseIndex = try FlatIndex(d: 4, metricType: .l2)
        let index = try RefineFlatIndex(baseIndex: baseIndex)

        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.count, 0)

        let data = matrix(rows: 100, columns: 4)
        try index.train(data)
        try index.add(data)

        XCTAssertEqual(index.count, 100)

        let result = try index.search([[0]], k: 4)
        XCTAssertEqual(result.labels, [[0, 1, 2, 3]])
        XCTAssertEqual(result.distances, [[14, 126, 366, 734]])
    }
}
