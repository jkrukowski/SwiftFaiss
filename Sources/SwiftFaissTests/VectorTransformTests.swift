@testable import SwiftFaiss
import XCTest

final class VectorTransformTests: XCTestCase {
    func testCenteringTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try CenteringTransform(d: 4)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 4)
        XCTAssertTrue(transform.isTrained)
    }

    func testITQMatrixTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try ITQMatrixTransform(d: 4)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 4)
        XCTAssertTrue(transform.isTrained)
        XCTAssertFalse(transform.isOrthonormal)
    }

    func testITQTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try ITQTransform(dIn: 4, dOut: 2, doPca: true)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 2)
        XCTAssertTrue(transform.isTrained)
    }

    func testNormalizationTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try NormalizationTransform(d: 4, norm: 2.0)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 4)
        XCTAssertTrue(transform.isTrained)
    }

    func testOPQMatrixTransform() throws {
        let data = matrix(rows: 10_000, columns: 4)
        let transform = try OPQMatrixTransform(d: 4, m: 2, d2: 2)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 2)
        XCTAssertTrue(transform.isTrained)
        XCTAssertTrue(transform.isOrthonormal)
    }

    func testPCAMatrixTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try PCAMatrixTransform(dIn: 4, dOut: 2, eigenPower: 1, randomRotation: false)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 2)
        XCTAssertTrue(transform.isTrained)
        XCTAssertFalse(transform.isOrthonormal)
    }

    func testRandomRotationMatrixTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try RandomRotationMatrixTransform(dIn: 4, dOut: 2)
        try transform.train(data)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 2)
        XCTAssertTrue(transform.isTrained)
        XCTAssertTrue(transform.isOrthonormal)
    }

    func testRemapDimensionsTransform() throws {
        let data = matrix(rows: 200, columns: 4)
        let transform = try RemapDimensionsTransform(dIn: 4, dOut: 2, uniform: true)
        _ = try transform.apply(data)

        XCTAssertEqual(transform.dIn, 4)
        XCTAssertEqual(transform.dOut, 2)
        XCTAssertTrue(transform.isTrained)
    }
}
