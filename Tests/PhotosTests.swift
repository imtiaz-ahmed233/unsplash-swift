// PhotosTests.swift
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

class PhotoTests: BaseTestCase {
    
    override func setUp() {
        super.setUp()
        Unsplash.setUpWithAppId(Config.appId, secret: Config.secret)
    }
    
    override func tearDown() {
        super.tearDown()
        Unsplash.unlinkClient()
    }
    
    func testPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.photos.findPhotos(2, perPage: nil).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testPhotosPerPage() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.photos.findPhotos(2, perPage: 20).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 20)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSearch() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.photos.search("cat").response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSearchWithCategory() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        let categories : Array<UInt32> = [2]
        client.photos.search("skyscraper", categoryIds: categories).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSearchWithCategories() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        let categories : Array<UInt32> = [2, 4]
        client.photos.search("skyscraper", categoryIds: categories).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSpecificPhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        client.photos.findPhoto("0NRherR9Xq8").response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertEqual(photo.id, "0NRherR9Xq8")
                XCTAssertNotNil(photo.categories)
                XCTAssertNotNil(photo.exif)
                XCTAssertEqual(photo.width, 2667)
                XCTAssertEqual(photo.height, 4000)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
                XCTAssertNotNil(photo.downloads)
                XCTAssertGreaterThan(photo.downloads!, 0)
                XCTAssertNotNil(photo.likes)
                XCTAssertGreaterThan(photo.likes!, 0)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testRandomPhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        client.photos.random().response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertNotNil(photo.categories)
                XCTAssertNotNil(photo.exif)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
}
