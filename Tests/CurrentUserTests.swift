// CurrentUserTests.swift
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

class CurrentUserTests : BaseTestCase {
        
    func testRetrieveProfile() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("current_user_profile")
        
        client.currentUser.profile().response({ response, error in
            XCTAssertNil(error)
            if let user = response {
                XCTAssertEqual(user.username, "jimmyexample")
                XCTAssertEqual(user.firstName, "James")
                XCTAssertEqual(user.lastName, "Example")
                XCTAssertNil(user.portfolioURL)
                XCTAssertEqual(user.downloads, 4321)
                XCTAssertEqual(user.bio, "He was born on a very cold day.")
                XCTAssertEqual(user.uploadsRemaining, 4)
                XCTAssertEqual(user.instagramUsername, "james-example")
                XCTAssertNil(user.location)
                XCTAssertEqual(user.email, "jim@example.com")
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
    func testUpdateProfile() {
        let expectation = expectationWithDescription("\(__FUNCTION__)")
        
        MockedURLProtocol.statusCode = 200
        MockedURLProtocol.responseData = Utils.dataForJSONFile("current_user_update")
        
        client.currentUser.updateProfile(firstName: "Jim", bio: "He was born on a very, VERY cold day.").response({ response, error in
            XCTAssertNil(error)
            if let user = response {
                XCTAssertEqual(user.username, "jimmyexample")
                XCTAssertEqual(user.firstName, "Jim")
                XCTAssertEqual(user.lastName, "Example")
                XCTAssertNil(user.portfolioURL)
                XCTAssertEqual(user.downloads, 4321)
                XCTAssertEqual(user.bio, "He was born on a very, VERY cold day.")
                XCTAssertEqual(user.uploadsRemaining, 4)
                XCTAssertEqual(user.instagramUsername, "james-example")
                XCTAssertNil(user.location)
                XCTAssertEqual(user.email, "jim@example.com")
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations()
    }
    
}