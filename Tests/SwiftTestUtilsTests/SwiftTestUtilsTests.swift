import XCTest
@testable import SwiftTestUtils

final class SwiftTestUtilsTests: XCTestCase {
    func testTestString() throws {
        do {
        guard let testString = try TestStrings(jsonPathFromApplicationSupportDirectory: "SwiftTestUtils/strings.json") else {
            XCTFail()
            return
        }
        try testString.addValue(name: "test", value: "value")
        let value = testString.fetchValue(name: "test")
        try testString.removeValue(name: "test")
        XCTAssertEqual(value, "value")
        } catch {
            XCTFail()
        }
    }
}
