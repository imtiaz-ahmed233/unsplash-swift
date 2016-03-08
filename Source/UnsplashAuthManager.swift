// UnsplashAuthManager.swift
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
import WebKit
import Security
import Alamofire

// TODO: Support different scope access.

public class UnsplashAuthManager {
    
    private static let host = "unsplash.com"
    private static let scopes = [
        "public",
        "read_user",
        "write_user",
        "read_photos",
        "write_photos",
        "write_likes",
        "read_collections",
        "write_collections"
    ]
    
    private let appId : String
    private let secret : String
    private let redirectURL : NSURL
    
    public static var sharedAuthManager : UnsplashAuthManager!
    
    public init(appId: String, secret: String) {
        self.appId = appId
        self.secret = secret
        self.redirectURL = NSURL(string: "unsplash-\(self.appId)://token")!
    }
    
    public func authorizeFromController(controller: UIViewController, completion:(UnsplashAccessToken?, NSError?) -> Void) {
        let connectController = UnsplashConnectController(startURL: self.authURL(), dismissOnMatchURL: self.redirectURL)
        connectController.onWillDismiss = { didCancel in
            if (didCancel) {
                completion(nil, Error.errorWithCode(.UserCanceledAuth, description: "User canceled authorization"))
            }
        }
        connectController.onMatchedURL = { url in
            self.retrieveAccessTokenFromURL(url, completion: completion)
        }
        let navigationController = UINavigationController(rootViewController: connectController)
        controller.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    private func retrieveAccessTokenFromURL(url: NSURL, completion: ((UnsplashAccessToken?, NSError?) -> Void)) {
        let (code, error) = extractCodeFromRedirectURL(url)
        
        if let e = error {
            completion(nil, e)
            return
        }
        
        Alamofire.request(.POST, accessTokenURL(code!)).validate().responseJSON { response in
            switch response.result {
            case .Success(let value):
                let token = UnsplashAccessToken(appId: self.appId, accessToken: value["access_token"]! as! String)
                Keychain.set(self.appId, value: token.accessToken)
                completion(token, nil)
            case .Failure(_):
                let error = self.extractErrorFromData(response.data!)
                completion(nil, error)
            }
        }
    }
    
    private func authURL() -> NSURL {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = UnsplashAuthManager.host
        components.path = "/oauth/authorize"
        
        components.queryItems = [
            NSURLQueryItem(name: "response_type", value: "code"),
            NSURLQueryItem(name: "client_id", value: self.appId),
            NSURLQueryItem(name: "redirect_uri", value: self.redirectURL.URLString),
            NSURLQueryItem(name: "scope", value: UnsplashAuthManager.scopes.joinWithSeparator("+")),
        ]
        return components.URL!
    }
    
    private func accessTokenURL(code: String) -> NSURL {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = UnsplashAuthManager.host
        components.path = "/oauth/token"
        
        components.queryItems = [
            NSURLQueryItem(name: "grant_type", value: "authorization_code"),
            NSURLQueryItem(name: "client_id", value: self.appId),
            NSURLQueryItem(name: "client_secret", value: self.secret),
            NSURLQueryItem(name: "redirect_uri", value: self.redirectURL.URLString),
            NSURLQueryItem(name: "code", value: code),
        ]
        return components.URL!
    }
    
    private func extractCodeFromRedirectURL(url: NSURL) -> (String?, NSError?) {
        let pairs = url.queryPairs
        if let error = pairs["error"] {
            let desc = pairs["error_description"]?.stringByReplacingOccurrencesOfString("+", withString: " ").stringByRemovingPercentEncoding
            return (nil, Error.errorWithCodeString(error, description: desc))
        } else {
            let code = pairs["code"]!
            return (code, nil)
        }
    }
    
    private func extractErrorFromData(data: NSData) -> NSError? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:String]
            return Error.errorWithCodeString(json!["error"]!, description: json!["error_description"])
        } catch {
            return nil
        }
    }
    
    public func getAccessToken() -> UnsplashAccessToken? {
        if let accessToken = Keychain.get(self.appId) {
            return UnsplashAccessToken(appId: self.appId, accessToken: accessToken)
        }
        return nil
    }
    
    public func clearAccessToken() -> Bool {
        return Keychain.clear()
    }
}

class UnsplashConnectController : UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    
    var onWillDismiss: ((didCancel: Bool) -> Void)?
    var onMatchedURL: ((url: NSURL) -> Void)?
    
    var cancelButton: UIBarButtonItem?
    
    let startURL : NSURL
    let dismissOnMatchURL : NSURL
    
    init(startURL: NSURL, dismissOnMatchURL: NSURL) {
        self.startURL = startURL
        self.dismissOnMatchURL = dismissOnMatchURL
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Link to Unsplash"
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        
        self.webView.navigationDelegate = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItem = self.cancelButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !webView.canGoBack {
            loadURL(startURL)
        }
    }
    
    func webView(webView: WKWebView,
        decidePolicyForNavigationAction navigationAction: WKNavigationAction,
        decisionHandler: (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.URL {
                if self.dimissURLMatchesURL(url) {
                    self.onMatchedURL?(url: url)
                    self.dismiss(true)
                    return decisionHandler(.Cancel)
                }
            }
            return decisionHandler(.Allow)
    }

    func loadURL(url: NSURL) {
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    func dimissURLMatchesURL(url: NSURL) -> Bool {
        if (url.scheme == self.dismissOnMatchURL.scheme &&
            url.host == self.dismissOnMatchURL.host &&
            url.path == self.dismissOnMatchURL.path) {
            return true
        }
        return false
    }
    
    func showHideBackButton(show: Bool) {
        navigationItem.leftBarButtonItem = show ? UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "goBack:") : nil
    }
    
    func goBack(sender: AnyObject?) {
        webView.goBack()
    }
    
    func cancel(sender: AnyObject?) {
        dismiss(true, animated: (sender != nil))
    }
    
    func dismiss(animated: Bool) {
        dismiss(false, animated: animated)
    }
    
    func dismiss(asCancel: Bool, animated: Bool) {
        webView.stopLoading()
        
        self.onWillDismiss?(didCancel: asCancel)
        presentingViewController?.dismissViewControllerAnimated(animated, completion: nil)
    }
}

public class UnsplashAccessToken : CustomStringConvertible {
    public let appId: String
    public let accessToken: String
    // TODO: Keep track of the refresh token.
    // public let refreshToken: String
    
    public init(appId: String, accessToken: String) {
        self.appId = appId
        self.accessToken = accessToken
    }
    
    public var description : String {
        return self.accessToken
    }
}

public struct Error {
    public static let Domain = "com.unsplash.error"
    public enum Code: Int {
        /// The client is not authorized to request an access token using this method.
        case UnauthorizedClient = 1
        
        /// The resource owner or authorization server denied the request.
        case AccessDenied
        
        /// The authorization server does not support obtaining an access token using this method.
        case UnsupportedResponseType
        
        /// The requested scope is invalid, unknown, or malformed.
        case InvalidScope
        
        /// The authorization server encountered an unexpected condition that prevented it from
        /// fulfilling the request.
        case ServerError
        
        /// Client authentication failed due to unknown client, no client authentication included,
        /// or unsupported authentication method.
        case InvalidClient
        
        /// The request is missing a required parameter, includes an unsupported parameter value, or
        /// is otherwise malformed.
        case InvalidRequest
        
        /// The provided authorization grant is invalid, expired, revoked, does not match the
        /// redirection URI used in the authorization request, or was issued to another client.
        case InvalidGrant
        
        /// The authorization server is currently unable to handle the request due to a temporary
        /// overloading or maintenance of the server.
        case TemporarilyUnavailable
        
        // The user canceled the authorization process.
        case UserCanceledAuth
        
        /// Some other error.
        case Unknown
    }
    
    static func errorWithCodeString(codeString: String, description: String?) -> NSError {
        var code : Code
        switch codeString {
        case "unauthorized_client": code = .UnauthorizedClient
        case "access_denied": code = .AccessDenied
        case "unsupported_response_type": code = .UnsupportedResponseType
        case "invalid_scope": code = .InvalidScope
        case "invalid_client": code = .InvalidClient
        case "server_error": code = .ServerError
        case "temporarily_unavailable": code = .TemporarilyUnavailable
        case "invalid_request": code = .InvalidRequest
        default: code = .Unknown
        }
        
        return errorWithCode(code, description: description)
    }
    
    static func errorWithCode(code: Code, description: String?) -> NSError {
        var info : [NSObject : AnyObject]?
        if let d = description {
            info = [NSLocalizedDescriptionKey : d]
        }
        return NSError(domain: Domain, code: code.rawValue, userInfo: info)
    }
}

class Keychain {
    
    class func queryWithDict(query: [String : AnyObject]) -> CFDictionaryRef {
        let bundleId = NSBundle.mainBundle().bundleIdentifier ?? ""
        var queryDict = query
        
        queryDict[kSecClass as String]       = kSecClassGenericPassword
        queryDict[kSecAttrService as String] = "\(bundleId).unsplash.auth"
        
        return queryDict
    }
    
    class func set(key: String, value: String) -> Bool {
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding) {
            return set(key, value: data)
        } else {
            return false
        }
    }
    
    class func set(key: String, value: NSData) -> Bool {
        let query = Keychain.queryWithDict([
            (kSecAttrAccount as String): key,
            (  kSecValueData as String): value
            ])
        
        SecItemDelete(query)
        
        return SecItemAdd(query, nil) == noErr
    }
    
    class func getAsData(key: String) -> NSData? {
        let query = Keychain.queryWithDict([
            (kSecAttrAccount as String): key,
            ( kSecReturnData as String): kCFBooleanTrue,
            ( kSecMatchLimit as String): kSecMatchLimitOne
            ])
        
        var dataResult : AnyObject?
        let status = withUnsafeMutablePointer(&dataResult) { (ptr) in
            SecItemCopyMatching(query, UnsafeMutablePointer(ptr))
        }
        
        if status == noErr {
            return dataResult as? NSData
        }
        
        return nil
    }

    class func get(key: String) -> String? {
        if let data = getAsData(key) {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        } else {
            return nil
        }
    }
    
    class func delete(key: String) -> Bool {
        let query = Keychain.queryWithDict([
            (kSecAttrAccount as String): key
            ])
        
        return SecItemDelete(query) == noErr
    }
    
    class func clear() -> Bool {
        let query = Keychain.queryWithDict([:])
        return SecItemDelete(query) == noErr
    }
}