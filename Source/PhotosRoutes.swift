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
    
    public func uploadPhoto(photo: UIImage, location: Location?=nil, exif: Exif?=nil) -> UnsplashRequest<Photo.Serializer> {
        precondition(client.authorized, "client is not authorized to make this request")
        
        let data = UIImageJPEGRepresentation(photo, 0.7)
        var params = [String : AnyObject]()
        params["photo"] = data!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        if let l = location {
            var locationParams = [String : AnyObject]()
            if l.city != nil { locationParams["city"] = l.city }
            if l.country != nil { locationParams["country"] = l.country }
            if l.name != nil { locationParams["name"] = l.name }
            if (l.confidential != nil && l.confidential!) { locationParams["confidential"] = "true" }
            params["location"] = locationParams
        }
        if let e = exif {
            var exifParams = [String : AnyObject]()
            if e.make != nil { exifParams["make"] = e.make }
            if e.model != nil { exifParams["model"] = e.model }
            if e.exposureTime != nil { exifParams["exposure_time"] = NSNumber(double: e.exposureTime!) }
            if e.aperture != nil { exifParams["aperture_value"] = NSNumber(double: e.aperture!) }
            if e.focalLength != nil { exifParams["focal_length"] = NSNumber(unsignedInt: e.focalLength!) }
            if e.iso != nil { exifParams["iso_speed_ratings"] = NSNumber(unsignedInt: e.iso!) }
            params["exif"] = exifParams
        }
        
        return UnsplashRequest(client: self.client, method: .POST, route: "/photos", auth: true, params: params, responseSerializer: Photo.Serializer())
    }
    
    public func updatePhoto(photoId: String, location: Location?=nil, exif: Exif?=nil) -> UnsplashRequest<Photo.Serializer> {
        precondition(client.authorized, "client is not authorized to make this request")

        var params : [String : AnyObject] = ["id" : photoId]
        if let l = location {
            var locationParams = [String : AnyObject]()
            if l.city != nil { locationParams["city"] = l.city }
            if l.country != nil { locationParams["country"] = l.country }
            if l.name != nil { locationParams["name"] = l.name }
            if (l.confidential != nil && l.confidential!) { locationParams["confidential"] = "true" }
            params["location"] = locationParams
        }
        if let e = exif {
            var exifParams = [String : AnyObject]()
            if e.make != nil { exifParams["make"] = e.make }
            if e.model != nil { exifParams["model"] = e.model }
            if e.exposureTime != nil { exifParams["exposure_time"] = NSNumber(double: e.exposureTime!) }
            if e.aperture != nil { exifParams["aperture_value"] = NSNumber(double: e.aperture!) }
            if e.focalLength != nil { exifParams["focal_length"] = NSNumber(unsignedInt: e.focalLength!) }
            if e.iso != nil { exifParams["iso_speed_ratings"] = NSNumber(unsignedInt: e.iso!) }
            params["exif"] = exifParams
        }
        return UnsplashRequest(client: self.client, method: .PUT, route: "/photos/\(photoId)", auth: true, params: params, responseSerializer: Photo.Serializer())
    }
    
    public func likePhoto(photoId: String) -> UnsplashRequest<PhotoUserResult.Serializer> {
        precondition(client.authorized, "client is not authorized to make this request")
        
        let params = ["id" : photoId]
        return UnsplashRequest(client: self.client, method: .POST, route: "/photos/\(photoId)/like", auth: true, params: params, responseSerializer: PhotoUserResult.Serializer())
    }
    
    public func unlikePhoto(photoId: String) -> UnsplashRequest<DeleteResultSerializer> {
        precondition(client.authorized, "client is not authorized to make this request")
        
        let params = ["id" : photoId]
        return UnsplashRequest(client: self.client, method: .DELETE, route: "/photos/\(photoId)/like", auth: true, params: params, responseSerializer: DeleteResultSerializer())
    }
    
}
