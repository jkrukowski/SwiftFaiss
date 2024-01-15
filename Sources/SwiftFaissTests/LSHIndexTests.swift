@testable import SwiftFaiss
import XCTest

final class LSHIndexTests: XCTestCase {
    func testLSHIndex() throws {
        let index = try LSHIndex(d: 4, nbits: 16)

        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.count, 0)

        let data = matrix(rows: 100, columns: 4)
        try index.train(data)
        try index.add(data)

        XCTAssertEqual(index.count, 100)

        let result = try index.search([[0]], k: 4)
        XCTAssertEqual(result.labels, [[2, 3, 4, 5]])
        XCTAssertEqual(result.distances, [[8, 8, 8, 8]])
    }
}
