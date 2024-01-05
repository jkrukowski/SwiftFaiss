@testable import SwiftFaiss
import XCTest

final class FaissIndexTests: XCTestCase {
    func testSearchEmptyIndexShouldThrow() throws {
        let index = try FaissIndex.flatL2(d: 32)
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 0)
        XCTAssertThrowsError(
            try index.search([Array(repeating: 1, count: 32)], k: 3)
        )
    }

    func testSearchNonEmptyIndexShouldReturnValues() throws {
        let index = try FaissIndex.flatL2(d: 4)
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 3)
        let result = try index.search([[1, 2, 3, 4]], k: 100)
        XCTAssertEqual(result.distances, [[0, 30, 2_430]])
        XCTAssertEqual(result.labels, [[0, 2, 1]])
    }
}
