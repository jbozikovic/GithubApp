//
//  RespositoryAPITests.swift
//  GithubAppTests
//
//  Created by Jurica Bozikovic on 31.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import XCTest
@testable import GithubApp
import Combine

final class RespositoryAPITests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
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

    func testGetRepositoriesFromAPI() {
        let apiService = RepositoryAPIService(networkLayerService: NetworkLayerService())
        let expectation = self.expectation(description: #function)
        var error: Error? = nil
        var repos: [Repository] = []
        apiService.searchRepositories(term: "swift", sort: "stars", itemsPerPage: 30, page: 1).sink { completion in
            switch completion {
            case .failure(let apiError):
                error = apiError
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { response in
            repos = response.repositories
        }.store(in: &cancellables)
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
        XCTAssertEqual(repos.isEmpty, false, "Not ok, array shouldn't be empty")
    }
}
