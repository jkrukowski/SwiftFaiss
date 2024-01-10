@testable import SwiftFaiss
import XCTest

final class IndexTests: XCTestCase {
    func testSearchEmptyIndexShouldThrow() throws {
        let index = try Index(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 0)
        XCTAssertThrowsError(
            try index.search([Array(repeating: 1, count: 4)], k: 3)
        )
    }

    func testSearchNonEmptyIndexShouldReturnValues() throws {
        let index = try Index(d: 4, metricType: .l2, description: "Flat")
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

    func testAddWithIdsAndSearchNonEmptyIndexShouldReturnValues() throws {
        let index = try Index(d: 4, metricType: .l2, description: "IVF\(5),Flat")
        var data: [[Float]] = []
        for i in 0 ..< 200 {
            data.append((0 ..< 4).map { index in Float(i + index) })
        }
        try index.train(data)
        try index.add(Array(data[...4]), ids: [5, 1, 10, 3, 8])
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 5)
        let result = try index.search([[1, 2, 3, 4]], k: 3)
        XCTAssertEqual(result.distances, [[0, 4, 4]])
        XCTAssertEqual(result.labels, [[1, 5, 10]])
    }

    func testIndexFactory() throws {
        let index1 = try Index(d: 4, metricType: .l2, description: "IVF\(4_096),Flat")
        let indexIVFFlat = try XCTUnwrap(index1.IVFFlat)
        XCTAssertEqual(indexIVFFlat.nlist, 4_096)
        XCTAssertEqual(indexIVFFlat.d, 4)
        XCTAssertNotNil(index1.IVF)
        XCTAssertNil(index1.LSH)

        let index2 = try Index(d: 4, metricType: .l2, description: "HNSW\(4_096),Flat")
        XCTAssertEqual(index2.d, 4)
        XCTAssertNil(index2.IVFFlat)
        XCTAssertNil(index2.IVF)
        XCTAssertNil(index2.LSH)

        let index3 = try Index(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index3.d, 4)
        XCTAssertNil(index3.IVFFlat)
        XCTAssertNil(index3.IVF)
        XCTAssertNil(index3.LSH)

        let index4 = try Index(d: 4, metricType: .l2, description: "LSH")
        XCTAssertEqual(index4.d, 4)
        XCTAssertNil(index4.IVFFlat)
        XCTAssertNil(index4.IVF)
        XCTAssertNotNil(index4.LSH)
    }
}
