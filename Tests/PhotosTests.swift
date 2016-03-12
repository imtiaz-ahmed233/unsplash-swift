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
                XCTAssertEqual(photo.categories!.count, 1)
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
    
    func testUploadPhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 201
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_upload")
        
        UIGraphicsBeginImageContext(CGSizeMake(1, 1))
        let context = UIGraphicsGetCurrentContext()
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        client.photos.uploadPhoto(image).response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertEqual(photo.id, "Dwu85P9SOIk")
                XCTAssertNotNil(photo.exif)
                XCTAssertEqual(photo.width, 2448)
                XCTAssertEqual(photo.height, 3264)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
                XCTAssertNotNil(photo.location)
                XCTAssertNotNil(photo.categories)
                XCTAssertEqual(photo.likes!, 24)
                XCTAssertEqual(photo.downloads!, 1345)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testUpdatePhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 201
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_update")
        
        client.photos.updatePhoto("Dwu85P9SOIk").response({ response, error in
            XCTAssertNil(error)
            if let photo = response {
                XCTAssertEqual(photo.id, "Dwu85P9SOIk")
                XCTAssertNotNil(photo.exif)
                XCTAssertEqual(photo.width, 2448)
                XCTAssertEqual(photo.height, 3264)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.url)
                XCTAssertNotNil(photo.location)
                XCTAssertNotNil(photo.categories)
                XCTAssertEqual(photo.likes!, 24)
                XCTAssertEqual(photo.downloads!, 1345)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testLikePhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 201
        MockedURLProtocol.responseData = Utils.dataForJSONFile("photos_like")
        
        client.photos.likePhoto("Dwu85P9SOIk").response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                let user = result.user
                XCTAssertEqual(user.id, "8VpB0GYJMZQ")
                let photo = result.photo
                XCTAssertEqual(photo.id, "LF8gK8-HGSg")
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testUnlikePhoto() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 204
        
        client.photos.unlikePhoto("Dwu85P9SOIk").response({ response, error in
            XCTAssertNil(error)
            if let success = response {
                XCTAssertTrue(success)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
}
