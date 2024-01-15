@testable import SwiftFaiss
import XCTest

final class IVFFlatIndexTests: XCTestCase {
    func testIVFFlatIndex() throws {
        let quantizer = try FlatIndex(d: 4, metricType: .l2)
        let index = try IVFFlatIndex(quantizer: quantizer, d: 4, nlist: 1)

        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.count, 0)
        XCTAssertEqual(index.nlist, 1)
        XCTAssertEqual(index.nprobe, 1)

        let data = matrix(rows: 100, columns: 4)
        try index.train(data)
        try index.add(data)

        XCTAssertEqual(index.count, 100)
    }
}
