// UsersRoutes.swift
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

public class UsersRoutes {
    
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func findUser(username: String, width: UInt32?=nil, height: UInt32?=nil) -> UnsplashRequest<User.Serializer> {
        var params : [String : AnyObject] = ["username" : username]
        if let w = width {
            params["width"] = NSNumber(unsignedInt: w)
        }
        if let h = height {
            params["height"] = NSNumber(unsignedInt: h)
        }
        return UnsplashRequest(client: self.client, route: "/users/\(username)", auth: false, params: params, responseSerializer: User.Serializer())
    }
    
    public func photosForUser(username: String) -> UnsplashRequest<PhotosResult.Serializer> {
        let params = ["username" : username]
        return UnsplashRequest(client: self.client, route: "/users/\(username)/photos", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
    
    public func likesForUser(username: String, page: UInt32?=nil, perPage: UInt32?=nil) -> UnsplashRequest<PhotosResult.Serializer> {
        var params : [String : AnyObject] = ["username" : username]
        if let p = page {
            params["page"] = NSNumber(unsignedInt: p)
        }
        if let pp = perPage {
            params["per_page"] = NSNumber(unsignedInt: pp)
        }
        return UnsplashRequest(client: self.client, route: "/users/\(username)/likes", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
}
