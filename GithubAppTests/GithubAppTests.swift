//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by Jurica Bozikovic on 22.03.2023..
//

import XCTest
@testable import GithubApp

final class GithubAppTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testShortenedInt() {
        let input = 11255
        let expected = "11.3K"
        XCTAssertEqual(input.shortened(), expected, "Not the same")
    }
    
    func testStringNilOrEmpty() {
        let input: String? = nil
        XCTAssertEqual(input.isNilOrEmpty, true, "Not satisfied")
    }

    func testIsValidUrl() {
        let input = "http://www.google.com"
        let url = Utility.isValidUrl(urlString: input)
        XCTAssertEqual(url != nil, true, "testIsValidUrl not satisfied")
    }    
}
