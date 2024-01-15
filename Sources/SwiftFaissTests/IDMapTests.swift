@testable import SwiftFaiss
import XCTest

final class IDMapTests: XCTestCase {
    func testEmptyIDMap() throws {
        let index = try IDMap(subIndex: FlatIndex(d: 4, metricType: .l2))
        XCTAssertEqual(index.idMap(), [])
    }

    func testNonEmptyIDMap() throws {
        let index = try IDMap(subIndex: FlatIndex(d: 4, metricType: .l2))
        let data: [[Float]] = [
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ]
        try index.add(data, ids: [4, 5, 10])

        XCTAssertEqual(index.idMap(), [4, 5, 10])
    }

    func testEmptyIDMap2() throws {
        let index = try IDMap2(subIndex: FlatIndex(d: 4, metricType: .l2))
        XCTAssertEqual(index.idMap(), [])
    }

    func testNonEmptyIDMap2() throws {
        let index = try IDMap2(subIndex: FlatIndex(d: 4, metricType: .l2))
        let data: [[Float]] = [
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ]
        try index.add(data, ids: [4, 5, 10])

        XCTAssertEqual(index.idMap(), [4, 5, 10])
        XCTAssertEqual(try index.reconstruct(10), [2, 4, 6, 8])
    }
}
