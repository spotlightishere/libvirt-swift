import XCTest

import libvirtTests

var tests = [XCTestCaseEntry]()
tests += libvirtTests.allTests()
XCTMain(tests)
