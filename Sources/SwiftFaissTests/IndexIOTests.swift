@testable import SwiftFaiss
import XCTest

final class IndexIOTests: XCTestCase {
    private let fileURL = URL(fileURLWithPath: "test.index")

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: fileURL)
    }

    func testSaveAndLoadEmptyIndex() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")

        try index.saveToFile(fileURL.path)
        let loadedIndex = try loadFromFile(fileURL.path)
        XCTAssertEqual(loadedIndex.count, 0)
    }

    func testSaveAndLoadNonEmptyIndex() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])

        try index.saveToFile(fileURL.path)
        let loadedIndex = try loadFromFile(fileURL.path)
        XCTAssertEqual(loadedIndex.count, 3)
    }

    func testSaveAndLoadNonEmptyIndexMmap() throws {
        let index = try AnyIndex(d: 4, metricType: .l2, description: "Flat")
        try index.add([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [2, 4, 6, 8]
        ])

        try index.saveToFile(fileURL.path)
        let loadedIndex = try loadFromFile(fileURL.path, ioFlag: .mmap)
        XCTAssertEqual(loadedIndex.count, 3)
    }
}
