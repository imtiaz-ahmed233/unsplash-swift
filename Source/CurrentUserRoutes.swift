// CurrentUserRoutes.swift
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

public class CurrentUserRoutes {
    let client : UnsplashClient
    
    public init(client: UnsplashClient) {
        self.client = client
    }
    
    public func profile() -> UnsplashRequest<User.Serializer> {
        precondition(client.authorized, "client is not authorized to make this request")
        
        return UnsplashRequest(client: self.client, route: "/me", auth: true, params: nil, responseSerializer: User.Serializer())
    }
    
    public func updateProfile(username: String?=nil, firstName: String?=nil, lastName: String?=nil, email: String?=nil, portfolioURL: NSURL?=nil, location: String?=nil,
        bio: String?=nil, instagramUsername: String?=nil) -> UnsplashRequest<User.Serializer> {
        precondition(client.authorized, "client is not authorized to make this request")
        
        var params = [String : AnyObject]()
        if let u = username {
            params["username"] = u
        }
        if let f = firstName {
            params["first_name"] = f
        }
        if let l = lastName {
            params["last_name"] = l
        }
        if let e = email {
            params["email"] = e
        }
        if let p = portfolioURL {
            params["url"] = p.absoluteString
        }
        if let l = location {
            params["location"] = l
        }
        if let b = bio {
            params["bio"] = b
        }
        if let i = instagramUsername {
            params["instagram_usernam"] = i
        }
        return UnsplashRequest(client: self.client, method:.PUT, route: "/me", auth: true, params: params, responseSerializer: User.Serializer())
    }
}

