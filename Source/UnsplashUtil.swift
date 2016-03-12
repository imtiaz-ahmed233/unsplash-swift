// UnsplashUtil.swift
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

import UIKit

public class Unsplash {
    
    public static var client : UnsplashClient?
    
    public static func setUpWithAppId(appId : String, secret : String, scopes: [String]=UnsplashAuthManager.publicScope) {
        precondition(UnsplashClient.sharedClient == nil, "only call `UnsplashClient.init` one time")
        
        UnsplashAuthManager.sharedAuthManager = UnsplashAuthManager(appId: appId, secret: secret, scopes: scopes)
        UnsplashClient.sharedClient = UnsplashClient(appId: appId)
        Unsplash.client = UnsplashClient.sharedClient
        
        if let token = UnsplashAuthManager.sharedAuthManager.getAccessToken() {
            UnsplashClient.sharedClient.accessToken = token
        }
    }
    
    public static func unlinkClient() {
        precondition(UnsplashClient.sharedClient != nil, "call `UnsplashClient.init` before calling this method")
        
        Unsplash.client = nil
        UnsplashClient.sharedClient = nil
        UnsplashAuthManager.sharedAuthManager.clearAccessToken()
        UnsplashAuthManager.sharedAuthManager = nil
    }
    
    public static func authorizeFromController(controller: UIViewController, completion:(Bool, NSError?) -> Void) {
        precondition(UnsplashAuthManager.sharedAuthManager != nil, "call `UnsplashAuthManager.init` before calling this method")
        precondition(!UnsplashClient.sharedClient.authorized, "client is already authorized")
        
        UnsplashAuthManager.sharedAuthManager.authorizeFromController(controller, completion: { token, error in
            if let accessToken = token {
                UnsplashClient.sharedClient.accessToken = accessToken
                completion(true, nil)
            } else  {
                completion(false, error!)
            }
        })
    }
}
