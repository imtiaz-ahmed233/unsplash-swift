// MockedURLProtocol.swift
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

import Foundation

class MockedURLProtocol : NSURLProtocol {
    
    static var responseData : NSData?
    static var statusCode : Int?
    
    override static func canInitWithRequest(request: NSURLRequest) -> Bool {
        return request.URL?.scheme == "https" && request.URL?.host == "api.unsplash.com" && request.URL?.path == "/me"
    }
    
    override func startLoading() {
        let request = self.request
        let client = self.client
        
        let response = NSHTTPURLResponse(
            URL: request.URL!,
            statusCode: MockedURLProtocol.statusCode!,
            HTTPVersion: "HTTP/1.1",
            headerFields: nil)
        client?.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy:.NotAllowed)
        client?.URLProtocol(self, didLoadData: MockedURLProtocol.responseData!)
        client?.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
    
    override static func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
}