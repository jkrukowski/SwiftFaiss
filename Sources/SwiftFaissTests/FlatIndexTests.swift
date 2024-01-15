@testable import SwiftFaiss
import XCTest

final class FlatIndexTests: XCTestCase {
    func testEmptyFlatIndex() throws {
        let index = try FlatIndex(d: 4, metricType: .l2)
        XCTAssertEqual(index.count, 0)
        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.xb(), [])
    }

    func testNonEmptyFlatIndex() throws {
        let index = try FlatIndex(d: 4, metricType: .l2)
        let data: [[Float]] = [
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ]
        try index.add(data)

        XCTAssertEqual(index.count, 3)
        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.xb(), data)
    }
}
