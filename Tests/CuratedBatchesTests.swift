// CuratedBatchesTests.swift
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

class CuratedBatchesTests: BaseTestCase {
    
    override func setUp() {
        super.setUp()
        Unsplash.setUpWithAppId(Config.appId, secret: Config.secret)
    }
    
    override func tearDown() {
        super.tearDown()
        Unsplash.unlinkClient()
    }
    
    func testFindBatches() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.curatedBatches.findBatches(1, perPage: nil).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.batches.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testFindBatchesPerPage() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        let perPage : UInt32 = 20
        
        client.curatedBatches.findBatches(perPage: perPage).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(UInt32(result.batches.count), perPage)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testSpecificBatch() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        let batchId : UInt32 = 109
        
        client.curatedBatches.findBatch(batchId).response({ response, error in
            XCTAssertNil(error)
            if let batch = response {
                XCTAssertEqual(batch.id, batchId)
                XCTAssertEqual(batch.curator.name, "Dan Snow")
                XCTAssertTrue(batch.publishedAt.isEqualToDate(NSDate(timeIntervalSince1970: 1455900777)))
//                  XCTAssertGreaterThan(batch.downloads, 0)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testCuratedBatchPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        let batchId : UInt32 = 109
        
        client.curatedBatches.photosForBatch(batchId).response({ response, error in
            XCTAssertNil(error)
            if let result = response {
                XCTAssertEqual(result.photos.count, 10)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testInvalidBatchIdForPhotos() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        client.curatedBatches.photosForBatch(UINT32_MAX).response({ response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }

}
