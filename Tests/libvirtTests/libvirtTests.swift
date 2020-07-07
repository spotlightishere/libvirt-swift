import XCTest
@testable import libvirt

final class libvirtTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(libvirt().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
