// PhotosRoutes.swift
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
import CoreGraphics

// Following need an authorized user before implementing.
// TODO: Upload a photo
// TODO: Update a photo
// TODO: Like a photo
// TODO: Unlike a photo

public class PhotosRoutes {
    
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func findPhotos(page: UInt32?=nil, perPage: UInt32?=nil) -> UnsplashRequest<PhotosResult.Serializer> {
        var params = [String : AnyObject]()
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/photos", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
    
    public func findPhoto(photoId: String, width: UInt32?=nil, height: UInt32?=nil, rect: CGRect?=nil) -> UnsplashRequest<Photo.Serializer> {
        var params : [String : AnyObject] = ["id" : photoId]
        if let w = width {
            params["w"] = NSNumber(unsignedInt: w)
        }
        if let h = height {
            params["h"] = NSNumber(unsignedInt: h)
        }
        if let r = rect {
            params["rect"] = "\(Int(r.origin.x)),\(Int(r.origin.y)),\(Int(r.size.width)),\(Int(r.size.height))"
        }
        return UnsplashRequest(client: self.client, route: "/photos/\(photoId)", auth: false, params: params, responseSerializer: Photo.Serializer())
    }
    
    public func search(query: String, categoryIds: Array<UInt32>?=nil, page: UInt32?=nil, perPage: UInt32?=nil) -> UnsplashRequest<PhotosResult.Serializer> {
        var params : [String : AnyObject] = ["query" : query]
        if let ids = categoryIds where ids.count > 0 {
            let strIds = ids.map({"\($0)"}).joinWithSeparator(",")
            params["category"] = strIds
        }
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/photos/search", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
    
    public func random(query: String?=nil, categoryIds: Array<UInt32>?=nil, featured: Bool?=nil, username: String?=nil, width: UInt32?=nil, height: UInt32?=nil) -> UnsplashRequest<Photo.Serializer> {
        var params = [String : AnyObject]()
        if let q = query {
            params["query"] = q
        }
        if let ids = categoryIds where ids.count > 0 {
            let strIds = ids.map({"\($0)"}).joinWithSeparator(",")
            params["category"] = strIds
        }
        if featured != nil && featured! {
            params["featured"] = "true"
        }
        if let u = username {
            params["username"] = u
        }
        if let w = width {
            params["w"] = NSNumber(unsignedInt: w)
        }
        if let h = height {
            params["h"] = NSNumber(unsignedInt: h)
        }
        return UnsplashRequest(client: self.client, route: "/photos/random", auth: false, params: nil, responseSerializer: Photo.Serializer())
    }
}