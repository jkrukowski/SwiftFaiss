@testable import SwiftFaiss
import XCTest

final class FaissIndexTests: XCTestCase {
    func testIndexFlatL2() throws {
        let index = try FaissIndex(d: 4, metricType: .l2, description: "Flat")
        try index.add([1, 2, 3, 4])
        try index.add([10, 20, 30, 40])
        try index.add([2, 4, 6, 8])
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 3)
        let result = try index.search([1, 2, 3, 4], k: 100)
        XCTAssertEqual(result.distances, [0, 30, 2430])
        XCTAssertEqual(result.labels, [0, 2, 1])
        XCTAssertEqual(try index.reconstruct(Int(result.labels[0])), [1, 2, 3, 4])
    }
}
