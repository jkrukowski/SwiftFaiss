@testable import SwiftFaiss
import XCTest

final class PreTransformIndexTests: XCTestCase {
    func testPreTransformIndex() throws {
        let index = try PreTransformIndex(
            vectorTransform: NormalizationTransform(d: 4, norm: 2.0),
            subIndex: FlatIndex(d: 4, metricType: .l2)
        )

        XCTAssertEqual(index.d, 4)
        XCTAssertEqual(index.metricType, .l2)
        XCTAssertEqual(index.count, 0)

        let data = matrix(rows: 100, columns: 4)
        try index.add(data)

        XCTAssertEqual(index.count, 100)

        let result = try index.search([[0, 5, 8, 4]], k: 4)
        XCTAssertEqual(result.labels, [[1, 2, 0, 3]])
        XCTAssertEqual(result.distances, [[0.2438102, 0.27582434, 0.2785862, 0.29259852]], accuracy: 1e-6)

        try index.prepend(vectorTransform: CenteringTransform(d: 4))
        try index.train(data)

        let result2 = try index.search([[0, 5, 8, 4]], k: 4)
        XCTAssertEqual(result2.labels, [[0, 1, 2, 3]])
        XCTAssertEqual(result2.distances, [[3.6000257, 3.9586294, 3.9854743, 3.9925559]], accuracy: 1e-6)
    }
}
