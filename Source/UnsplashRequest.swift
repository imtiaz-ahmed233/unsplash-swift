// UnsplashRequest.swift
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

public class UnsplashRequest<RType : JSONSerializer> {
    let responseSerializer : RType
    let request : Alamofire.Request
    
    init(client: UnsplashClient, route: String, auth: Bool, params: [String : AnyObject]?, responseSerializer: RType) {
        self.responseSerializer = responseSerializer
        
        let url = "\(client.host)\(route)"
        let headers = client.additionalHeaders(auth)
        
        self.request = client.manager.request(.GET, url, parameters: params, encoding: ParameterEncoding.URL, headers: headers)
        request.resume()
    }
    
    static func authNeededForRoute(route: String) -> Bool {
        return route.containsString("curated_batches")
    }
    
    public func response(completionHandler: (RType.ValueType?, CallError?) -> Void) -> Self {
        self.request.validate().responseJSON { response in
            if (response.result.isFailure) {
                completionHandler(nil, self.handleResponseError(response))
            } else {
                let value = response.result.value!
                completionHandler(self.responseSerializer.deserialize(objectToJSON(value)), nil)
            }
        }
        
        return self
    }
    
    func handleResponseError(response: Response<AnyObject, NSError>) -> CallError {
        let _response = response.response
        let data = response.data
        let error = response.result.error
        let requestId = _response?.allHeaderFields["X-Request-Id"] as? String
        if let code = _response?.statusCode {
            switch code {
            case 500...599:
                var message = ""
                if let d = data {
                    message = utf8Decode(d)
                }
                return .InternalServerError(code, message, requestId)
            case 400:
                var message = ""
                if let d = data {
                    message = utf8Decode(d)
                }
                return .BadInputError(message, requestId)
            case 429:
                return .RateLimitError
            case 403, 404, 409:
                let json = parseJSON(data!)
                switch json {
                case .Dictionary(let d):
                    return .RouteError(ArraySerializer(StringSerializer()).deserialize(d["errors"]!), requestId)
                default:
                    fatalError("Failed to parse error type")
                }
            case 200:
                return .OSError(error)
            default:
                return .HTTPError(code, "An error occurred.", requestId)
            }
        } else {
            var message = ""
            if let d = data {
                message = utf8Decode(d)
            }
            return .HTTPError(nil, message, requestId)
        }
        return .HTTPError(nil, "", "")
    }
}

public enum CallError : CustomStringConvertible {
    case InternalServerError(Int, String?, String?)
    case BadInputError(String?, String?)
    case RateLimitError
    case HTTPError(Int?, String?, String?)
    case RouteError(Array<String>, String?)
    case OSError(ErrorType?)
    
    public var description : String {
        switch self {
        case let .InternalServerError(code, message, requestId):
            var ret = ""
            if let r = requestId {
                ret += "[request-id \(r)] "
            }
            ret += "Internal Server Error \(code)"
            if let m = message {
                ret += ": \(m)"
            }
            return ret
        case let .BadInputError(message, requestId):
            var ret = ""
            if let r = requestId {
                ret += "[request-id \(r)] "
            }
            ret += "Bad Input"
            if let m = message {
                ret += ": \(m)"
            }
            return ret
        case .RateLimitError:
            return "Rate limited"
        case let .HTTPError(code, message, requestId):
            var ret = ""
            if let r = requestId {
                ret += "[request-id \(r)] "
            }
            ret += "HTTP Error"
            if let c = code {
                ret += "\(c)"
            }
            if let m = message {
                ret += ": \(m)"
            }
            return ret
        case let .RouteError(message, requestId):
            var ret = ""
            if let r = requestId {
                ret += "[request-id \(r)] "
            }
            ret += "API route error - \(message)"
            return ret
        case let .OSError(err):
            if let e = err {
                return "\(e)"
            }
            return "An unknown system error"
        }
    }
}

func utf8Decode(data: NSData) -> String {
    return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
}
