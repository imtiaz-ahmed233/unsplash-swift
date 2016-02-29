// CategoriesTests.swift
//
// Copyright (c) 2016 Camden Fullmer (http://camdenfullmer.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
import UnsplashSwift

class CategoriesTests: BaseTestCase {
    
    override func setUp() {
        super.setUp()
        Unsplash.setUpWithAppId(Config.appId, secret: Config.secret)
    }
    
    override func tearDown() {
        super.tearDown()
        Unsplash.unlinkClient()
    }
    
    func testAllCategories() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.categories.all().response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertGreaterThan(result.categories.count, 0)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }

    func testSpecificCategory() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.categories.findCategory(2).response({ response, error in
            XCTAssertNil(error)
            if let category = response {
                XCTAssertEqual(category.id, 2)
                XCTAssertEqual(category.title, "Buildings")
                XCTAssertGreaterThan(category.photoCount, 0)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testCategoryPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.categories.photosForCategory(2, page: nil, perPage: nil).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    // FIXME: This test fails because the per page parameter has no effect. Problem with API?
    func _testCategoryPhotosPerPage() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.categories.photosForCategory(2, page: nil, perPage: 20).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 20)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
}
