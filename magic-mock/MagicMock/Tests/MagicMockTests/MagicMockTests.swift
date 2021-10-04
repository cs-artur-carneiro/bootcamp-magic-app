import XCTest
@testable import MagicMock

final class MagicMockTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MagicMock().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
