// CuratedBatchesRoutes.swift
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
import Alamofire

public class CuratedBatchesRoutes {
    
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func latestPage() -> UnsplashRequest<CuratedBatchesPage.Serializer> {
        return UnsplashRequest(client: self.client, route: "/curated_batches", params: nil, responseSerializer: CuratedBatchesPage.Serializer())
    }
    
    public func findPage(page: UInt32?, perPage: UInt32?) -> UnsplashRequest<CuratedBatchesPage.Serializer> {
        var params = [String : AnyObject]()
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/curated_batches", params: params, responseSerializer: CuratedBatchesPage.Serializer())
    }
    
    public func findBatch(batchId: UInt32) -> UnsplashRequest<CuratedBatch.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: batchId)]
        return UnsplashRequest(client: self.client, route: "/curated_batches/\(batchId)", params: params, responseSerializer: CuratedBatch.Serializer())
    }
    
    public func photosForBatch(batchId: UInt32) -> UnsplashRequest<CuratedBatchPhotosResult.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: batchId)]
        return UnsplashRequest(client: self.client, route: "/curated_batches/\(batchId)/photos", params: params, responseSerializer: CuratedBatchPhotosResult.Serializer())
    }
}
