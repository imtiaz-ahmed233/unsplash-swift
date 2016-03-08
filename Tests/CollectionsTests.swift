// CollectionsTests.swift
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
import Alamofire
import UnsplashSwift

class CollectionsTests: BaseTestCase {
    
    func testFindCollections() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_list")
        
        client.collections.findCollections(1, perPage: nil).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.collections.count, 1)
                let collection = result.collections.first!
                XCTAssertEqual(collection.id, 296)
                XCTAssertEqual(collection.title, "I like a man with a beard.")
                XCTAssertNotNil(collection.user)
                XCTAssertNotNil(collection.publishedAt)
                XCTAssertNotNil(collection.coverPhoto)
                XCTAssertFalse(collection.curated)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testFindCuratedCollections() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")

        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_list_curated")
        
        client.collections.findCuratedCollections().response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.collections.count, 1)
                let collection = result.collections.first!
                XCTAssertEqual(collection.id, 296)
                XCTAssertEqual(collection.title, "I like a man with a beard.")
                XCTAssertNotNil(collection.user)
                XCTAssertNotNil(collection.publishedAt)
                XCTAssertNotNil(collection.coverPhoto)
                XCTAssertTrue(collection.curated)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSpecificCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_specific")
        
        client.collections.findCollection(206).response({ response, error in
            XCTAssertNil(error)
            if let collection = response {
                XCTAssertEqual(collection.id, 206)
                XCTAssertEqual(collection.title, "Makers: Cat and Ben")
                XCTAssertNotNil(collection.user)
                XCTAssertNotNil(collection.publishedAt)
                XCTAssertNotNil(collection.coverPhoto)
                XCTAssertFalse(collection.curated)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testCollectionPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")

        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_photos")
        
        client.collections.photosForCollection(1).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 1)
                let photo = result.photos.first!
                XCTAssertEqual(photo.id, "sXKoi7ifLno")
                XCTAssertEqual(photo.width, 6240)
                XCTAssertEqual(photo.height, 4912)
                XCTAssertNotNil(photo.color)
                XCTAssertNotNil(photo.user)
                XCTAssertNotNil(photo.categories)
                XCTAssertNotNil(photo.url)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }

    func testCreateCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_create")
        
        client.collections.createCollection("Apple Watch").response { response, error in
            XCTAssertNil(error)
            if let collection = response {
                XCTAssertEqual(collection.id, 205)
                XCTAssertEqual(collection.title, "Apple Watch")
                XCTAssertNotNil(collection.user)
                XCTAssertNotNil(collection.publishedAt)
                XCTAssertNotNil(collection.coverPhoto)
                XCTAssertFalse(collection.curated)
            }
            
            expectation.fulfill()
        }

        waitForExpectations()
    }
    
    func testUpdateCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_update")
        
        client.collections.updateCollection(205, title: "Apple Watch").response { response, error in
            XCTAssertNil(error)
            if let collection = response {
                XCTAssertEqual(collection.id, 205)
                XCTAssertEqual(collection.title, "Apple Watch")
                XCTAssertNotNil(collection.user)
                XCTAssertNotNil(collection.publishedAt)
                XCTAssertNotNil(collection.coverPhoto)
                XCTAssertFalse(collection.curated)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testDeleteCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 204
        MockedURLProtocol.responseData = nil
        
        client.collections.deleteCollection(1).response { response, error in
            XCTAssertNil(error)
            XCTAssertTrue(response!)
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testAddPhotoCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("collections_add_photo")
        
        client.collections.addPhotoToCollection(298, photoId: "cnwIyn_BTkc").response { response, error in
            XCTAssertNil(error)
            
            let collection = response!.collection
            let photo = response!.photo
            
            XCTAssertEqual(collection.id, 298)
            XCTAssertEqual(collection.title, "API test")
            XCTAssertNotNil(collection.user)
            XCTAssertNotNil(collection.publishedAt)
            XCTAssertNotNil(collection.coverPhoto)
            XCTAssertFalse(collection.curated)
            
            XCTAssertEqual(photo.id, "cnwIyn_BTkc")
            XCTAssertNil(photo.width)
            XCTAssertNil(photo.height)
            XCTAssertNil(photo.color)
            XCTAssertNotNil(photo.user)
            XCTAssertNotNil(photo.categories)
            XCTAssertNotNil(photo.url)
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testRemovePhotoCollection() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 204
        MockedURLProtocol.responseData = nil
        
        client.collections.removePhotoToCollection(1, photoId: 1).response { response, error in
            XCTAssertNil(error)
            XCTAssertTrue(response!)
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
}
