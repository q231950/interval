#if os(Linux)
    import Glibc
#else
    import Darwin
    #endif

import Foundation
import XCTest
@testable import Controller

class ControllerTests: XCTestCase {

    static var allTests = [
    ("testRoute", testRoute),
    ]

    func testRoute() {
        XCTAssertTrue(true)
    }
}
