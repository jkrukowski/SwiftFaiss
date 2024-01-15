@testable import SwiftFaiss
import XCTest

final class AnyIndexTests: XCTestCase {
    func testAddShouldIncreaseCount() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.count, 0)
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])
        XCTAssertEqual(index.count, 3)
    }

    func testAddWithIdsShouldIncreaseCount() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "IVF\(5),Flat")
        XCTAssertEqual(index.count, 0)
        let data = matrix(rows: 200, columns: 4)
        try index.train(data)
        try index.add(Array(data[...4]), ids: [5, 1, 10, 3, 8])
        XCTAssertEqual(index.count, 5)
    }

    func testAssignEmptyIndexShouldThrow() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 0)
        XCTAssertThrowsError(
            try index.assign([[1, 1, 1, 1]], k: 3)
        )
    }

    func testAssignNonEmptyIndexShouldReturnValues() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 3)
        let result = try index.assign([[1, 2, 3, 4]], k: 100)
        XCTAssertEqual(result, [[0, 2, 1]])
    }

    func testReconstructEmptyIndexShouldThrow() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "IVF\(5),Flat")
        XCTAssertEqual(index.count, 0)
        let data = matrix(rows: 200, columns: 4)
        try index.train(data)
        let idx = try XCTUnwrap(index.toIVF())
        try idx.makeDirectMap()
        XCTAssertThrowsError(try idx.reconstruct(1))
    }

    func testReconstructNonEmptyIndexShouldReturnValue() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "IVF\(5),Flat")
        XCTAssertEqual(index.count, 0)
        let data = matrix(rows: 200, columns: 4)
        try index.train(data)
        try index.add(Array(data[...4]))
        let idx = try XCTUnwrap(index.toIVF())
        try idx.makeDirectMap()
        XCTAssertEqual(try idx.reconstruct(1), [4, 5, 6, 7])
    }

    func testRemoveIdsShouldReturnRemovedCount() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.count, 0)
        XCTAssertEqual(try index.removeIds(1 ..< 2), 0)
        try index.add(matrix(rows: 10, columns: 4))
        XCTAssertEqual(try index.removeIds(0 ..< 2), 2)
        XCTAssertEqual(try index.removeIds([0, 2, 5, 100]), 3)
    }

    func testResetShouldResetCount() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.count, 0)
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])
        XCTAssertEqual(index.count, 3)
        try index.reset()
        XCTAssertEqual(index.count, 0)
    }

    func testSearchEmptyIndexShouldThrow() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 0)
        XCTAssertThrowsError(
            try index.search([[1, 1, 1, 1]], k: 3)
        )
    }

    func testSearchNonEmptyIndexShouldReturnValues() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
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
        let index = try AnyIndex(d: 4, metricType: .l2, description: "IVF\(5),Flat")
        let data = matrix(rows: 200, columns: 4)
        try index.train(data)
        try index.add(Array(data[...4]), ids: [5, 1, 10, 3, 8])
        XCTAssertEqual(index.isTrained, true)
        XCTAssertEqual(index.count, 5)
        let result = try index.search([[1, 2, 3, 4]], k: 3)
        XCTAssertEqual(result.distances, [[4, 36, 196]])
        XCTAssertEqual(result.labels, [[5, 1, 10]])
    }

    func testIndexFactory() throws {
        let index1 = try AnyIndex(d: 4, metricType: .l2, description: "IVF\(4_096),Flat")
        let indexIVFFlat = try XCTUnwrap(index1.toIVFFlat())
        XCTAssertEqual(indexIVFFlat.nlist, 4_096)
        XCTAssertEqual(indexIVFFlat.d, 4)
        XCTAssertNotNil(index1.toIVF())
        XCTAssertNil(index1.toLSH())
        XCTAssertNil(index1.toRefineFlat())
        XCTAssertNil(index1.toIDMap())
        XCTAssertNil(index1.toIDMap2())

        let index2 = try AnyIndex(d: 4, metricType: .l2, description: "HNSW\(4_096),Flat")
        XCTAssertEqual(index2.d, 4)
        XCTAssertNil(index2.toIVFFlat())
        XCTAssertNil(index2.toIVF())
        XCTAssertNil(index2.toLSH())
        XCTAssertNil(index2.toRefineFlat())
        XCTAssertNil(index2.toIDMap())
        XCTAssertNil(index2.toIDMap2())

        let index3 = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        XCTAssertEqual(index3.d, 4)
        XCTAssertNil(index3.toIVFFlat())
        XCTAssertNil(index3.toIVF())
        XCTAssertNil(index3.toLSH())
        XCTAssertNil(index3.toIDMap())
        XCTAssertNil(index3.toRefineFlat())
        XCTAssertNil(index3.toIDMap())
        XCTAssertNil(index3.toIDMap2())

        let index4 = try AnyIndex(d: 4, metricType: .l2, description: "LSH")
        XCTAssertEqual(index4.d, 4)
        XCTAssertNil(index4.toIVFFlat())
        XCTAssertNil(index4.toIVF())
        XCTAssertNotNil(index4.toLSH())
        XCTAssertNil(index4.toRefineFlat())
        XCTAssertNil(index4.toIDMap())
        XCTAssertNil(index4.toIDMap2())

        let index5 = try AnyIndex(d: 4, metricType: .l2, description: "IDMap,Flat")
        XCTAssertEqual(index5.d, 4)
        XCTAssertNil(index5.toIVFFlat())
        XCTAssertNil(index5.toIVF())
        XCTAssertNil(index5.toLSH())
        XCTAssertNil(index5.toRefineFlat())
        XCTAssertNotNil(index5.toIDMap())
        XCTAssertNil(index5.toIDMap2())

        let index6 = try AnyIndex(d: 4, metricType: .l2, description: "IDMap2,Flat")
        XCTAssertEqual(index6.d, 4)
        XCTAssertNil(index6.toIVFFlat())
        XCTAssertNil(index6.toIVF())
        XCTAssertNil(index6.toLSH())
        XCTAssertNil(index6.toRefineFlat())
        XCTAssertNotNil(index6.toIDMap())
        XCTAssertNotNil(index6.toIDMap2())
    }

    func testInitWithInvalidDescriptionShouldThrow() {
        XCTAssertThrowsError(
            try AnyIndex(d: 4, metricType: .l2, description: "Invalid")
        )
    }

    func testClone() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        let cloned = try index.clone()
        XCTAssertFalse(cloned === index)
    }
}
