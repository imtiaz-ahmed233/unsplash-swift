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
    
    func testPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_list")
        
        client.photos.findPhotos().response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 1)
                let photo = result.photos.first!
                XCTAssertEqual(photo.id, "cssvEZacHvQ")
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
    
    func testSearch() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_search")
        
        client.photos.search("search").response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 1)
                let photo = result.photos.first!
                XCTAssertEqual(photo.id, "cssvEZacHvQ")
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
    
    func testSpecificPhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_specific")
        
        client.photos.findPhoto("Dwu85P9SOIk").response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertEqual(photo.id, "Dwu85P9SOIk")
                XCTAssertEqual(photo.categories.count, 1)
                XCTAssertNotNil(photo.exif)
                XCTAssertEqual(photo.width, 2448)
                XCTAssertEqual(photo.height, 3264)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
                XCTAssertEqual(photo.downloads!, 1345)
                XCTAssertEqual(photo.likes!, 24)
                XCTAssertNotNil(photo.location)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testRandomPhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_random")
        
        client.photos.random().response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertEqual(photo.id, "Dwu85P9SOIk")
                XCTAssertNil(photo.exif)
                XCTAssertEqual(photo.width, 2448)
                XCTAssertEqual(photo.height, 3264)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
                XCTAssertEqual(photo.downloads!, 1345)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
}
