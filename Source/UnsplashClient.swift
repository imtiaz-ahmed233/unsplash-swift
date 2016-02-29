// UnsplashClient.swift
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

public class UnsplashClient {
    
    let host : String
    let manager : Manager
    let appId : String
    public var curatedBatches : CuratedBatchesRoutes!
    public var categories : CategoriesRoutes!
    public var stats : StatsRoutes!
    public var photos : PhotosRoutes!
    
    public static var sharedClient : UnsplashClient!
    
    public init(appId: String, manager: Manager, host: String) {
        self.appId = appId
        self.host = host
        self.manager = manager
        self.curatedBatches = CuratedBatchesRoutes(client: self)
        self.categories = CategoriesRoutes(client: self)
        self.stats = StatsRoutes(client: self)
        self.photos = PhotosRoutes(client: self)
    }
    
    public convenience init(appId: String) {
        let manager = Manager()
        manager.startRequestsImmediately = false
        self.init(appId: appId, manager: manager, host: "https://api.unsplash.com")
    }
    
    public func additionalHeaders(authNeeded: Bool) -> [String : String] {
        var headers = [
            "Accept-Version" : "v1",
            "Content-Type" : "application/json",
        ]
        if (authNeeded) {
            // TODO: Access token will get set here.
        } else {
            headers["Authorization"] = "Client-ID \(self.appId)"
        }
        return headers
    }
    
}
