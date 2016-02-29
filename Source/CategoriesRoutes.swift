// CategoriesSwift.routes
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

public class CategoriesRoutes {
    
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func all() -> UnsplashRequest<CategoriesResult.Serializer> {
        return UnsplashRequest(client: self.client, route: "/categories", auth: false, params: nil, responseSerializer: CategoriesResult.Serializer())
    }
    
    public func findCategory(categoryId: UInt32) -> UnsplashRequest<Category.Serializer> {
        let params = ["id" : NSNumber(unsignedInt: categoryId)]
        return UnsplashRequest(client: self.client, route: "/categories/\(categoryId)", auth: false, params: params, responseSerializer: Category.Serializer())
    }
    
    public func photosForCategory(categoryId: UInt32, page: UInt32?, perPage: UInt32?) -> UnsplashRequest<PhotosResult.Serializer> {
        var params = ["id" : NSNumber(unsignedInt: categoryId)]
        if let page = page {
            params["page"] = NSNumber(unsignedInt: page)
        }
        if let perPage = perPage {
            params["per_page"] = NSNumber(unsignedInt: perPage)
        }
        return UnsplashRequest(client: self.client, route: "/curated_batches/\(categoryId)/photos", auth: false, params: params, responseSerializer: PhotosResult.Serializer())
    }
}
