// CollectionsRoutes.swift
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

public class CollectionsRoutes {
    
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func findCollections(page: UInt32?=nil, perPage: UInt32?=nil) -> UnsplashRequest<CollectionsResult.Serializer> {
        var params = [String : AnyObject]()
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/collections", auth: false, params: params, responseSerializer: CollectionsResult.Serializer())
    }
    
    public func findCuratedCollections(page: UInt32?=nil, perPage: UInt32?=nil) -> UnsplashRequest<CollectionsResult.Serializer> {
        var params = [String : AnyObject]()
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/collections/curated", auth: false, params: params, responseSerializer: CollectionsResult.Serializer())
    }
    
    public func findCollection(collectionId: UInt32) -> UnsplashRequest<Collection.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: collectionId)]
        return UnsplashRequest(client: self.client, route: "/collections/\(collectionId)", auth: false, params: params, responseSerializer: Collection.Serializer())
    }
    
    public func findCuratedCollection(collectionId: UInt32) -> UnsplashRequest<Collection.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: collectionId)]
        return UnsplashRequest(client: self.client, route: "/collections/curatd/\(collectionId)", auth: false, params: params, responseSerializer: Collection.Serializer())
    }
    
    public func photosForCollection(collectionId: UInt32) -> UnsplashRequest<PhotosResult.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: collectionId)]
        return UnsplashRequest(client: self.client, route: "/collections/\(collectionId)/photos", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }

    public func photosForCuratedCollection(collectionId: UInt32) -> UnsplashRequest<PhotosResult.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: collectionId)]
        return UnsplashRequest(client: self.client, route: "/collections/curated/\(collectionId)/photos", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
    
    public func createCollection(title: String, description: String?=nil, isPrivate: Bool=false ) -> UnsplashRequest<Collection.Serializer> {
        var params : [String : AnyObject] = ["title" : title]
        if let d = description {
            params["description"] = d
        }
        if isPrivate {
            params["private"] = "true"
        }
        return UnsplashRequest(client: self.client, method: .POST, route: "/collections", auth: true, params: params, responseSerializer: Collection.Serializer())
    }
    
    public func updateCollection(collectionId: UInt32, title: String?=nil, description: String?=nil, isPrivate: Bool=false) -> UnsplashRequest<Collection.Serializer> {
        var params : [String : AnyObject] = ["id" : NSNumber(unsignedInt: collectionId)]
        if let t = title {
            params["title"] = t
        }
        if let d = description {
            params["description"] = d
        }
        if isPrivate {
            params["private"] = "true"
        }
        return UnsplashRequest(client: self.client, method: .PUT, route: "/collections/\(collectionId)", auth: true, params: params, responseSerializer: Collection.Serializer())
    }
    
    public func deleteCollection(collectionId: UInt32) -> UnsplashRequest<DeleteResultSerializer> {
        let params = ["id" : NSNumber(unsignedInt: collectionId)]
        return UnsplashRequest(client: self.client, method: .DELETE, route: "/collections/\(collectionId)", auth: true, params: params, responseSerializer: DeleteResultSerializer())
    }
    
    public func addPhotoToCollection(collectionId: UInt32, photoId: String) -> UnsplashRequest<PhotoCollectionResult.Serializer> {
        let params = [
            "collection_id" : NSNumber(unsignedInt: collectionId),
            "photo_id" : photoId
        ]
        return UnsplashRequest(client: self.client, method: .POST, route: "/collections/\(collectionId)/add", auth: true, params: params, responseSerializer: PhotoCollectionResult.Serializer())
    }
    
    public func removePhotoToCollection(collectionId: UInt32, photoId: UInt32) -> UnsplashRequest<DeleteResultSerializer> {
        let params = [
            "collection_id" : NSNumber(unsignedInt: collectionId),
            "photo_id" : NSNumber(unsignedInt: photoId)
        ]
        return UnsplashRequest(client: self.client, method: .DELETE, route: "/collections/\(collectionId)/remove", auth: true, params: params, responseSerializer: DeleteResultSerializer())
    }

}
