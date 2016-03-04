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
    
    func testAllCategories() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("categories_all")
        
        client.categories.all().response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.categories.count, 1)
                XCTAssertEqual(result.categories.first!.id, 2)
                XCTAssertEqual(result.categories.first!.title, "Buildings")
                XCTAssertEqual(result.categories.first!.photoCount, 3428)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }

    func testSpecificCategory() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("categories_specific")
        
        client.categories.findCategory(2).response({ response, error in
            XCTAssertNil(error)
            if let category = response {
                XCTAssertEqual(category.id, 2)
                XCTAssertEqual(category.title, "Buildings")
                XCTAssertEqual(category.photoCount, 3428)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testCategoryPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("categories_photos")
        
        client.categories.photosForCategory(2).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 1)
                let photo = result.photos.first!
                XCTAssertEqual(photo.id, "lk-cRCSRI7s")
                XCTAssertEqual(photo.width, 5245)
                XCTAssertEqual(photo.height, 3497)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.url)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
}
