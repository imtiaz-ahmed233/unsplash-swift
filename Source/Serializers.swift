// Serializers.swift
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
import CoreGraphics

// TODO: Create struct to hold single instance for all serializers.

public enum JSON {
    case Array([JSON])
    case Dictionary([String: JSON])
    case Str(String)
    case Number(NSNumber)
    case Null
}

public protocol JSONSerializer {
    typealias ValueType
    func deserialize(_: JSON) -> ValueType
}

func objectToJSON(json : AnyObject) -> JSON {
    
    switch json {
    case _ as NSNull:
        return .Null
    case let num as NSNumber:
        return .Number(num)
    case let str as String:
        return .Str(str)
    case let dict as [String : AnyObject]:
        var ret = [String : JSON]()
        for (k, v) in dict {
            ret[k] = objectToJSON(v)
        }
        return .Dictionary(ret)
    case let array as [AnyObject]:
        return .Array(array.map(objectToJSON))
    default:
        fatalError("Unknown type trying to parse JSON.")
    }
}

func parseJSON(data: NSData) -> JSON {
    let obj: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
    return objectToJSON(obj)
}

// MARK: - Common Serializers

public class ArraySerializer<T : JSONSerializer> : JSONSerializer {
    
    var elementSerializer : T
    
    init(_ elementSerializer: T) {
        self.elementSerializer = elementSerializer
    }
    
    public func deserialize(json : JSON) -> Array<T.ValueType> {
        switch json {
        case .Array(let arr):
            return arr.map { self.elementSerializer.deserialize($0) }
        default:
            fatalError("Type error deserializing")
        }
    }
}
public class UInt32Serializer : JSONSerializer {
    public func deserialize(json : JSON) -> UInt32 {
        switch json {
        case .Number(let n):
            return n.unsignedIntValue
        default:
            fatalError("Type error deserializing")
        }
    }
}
public class StringSerializer : JSONSerializer {
    public func serialize(value : String) -> JSON {
        return .Str(value)
    }
    
    public func deserialize(json: JSON) -> String {
        switch (json) {
        case .Str(let s):
            return s
        default:
            fatalError("Type error deserializing")
        }
    }
}
// Color comes in the following format: #000000
public class UIColorSerializer : JSONSerializer {
    public func deserialize(json: JSON) -> UIColor {
        switch (json) {
        case .Str(let s):
            return UIColor.colorWithHexString(s)
    default:
            fatalError("Type error deserializing")
        }
    }
}
public class NSURLSerializer : JSONSerializer {
    public func deserialize(json: JSON) -> NSURL {
        switch (json) {
        case .Str(let s):
            return NSURL(string: s)!
        default:
            fatalError("Type error deserializing")
        }
    }
}
// Date comes in the following format: 2015-06-17T11:53:00-04:00
public class NSDateSerializer : JSONSerializer {
    var dateFormatter : NSDateFormatter
    
    init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }    
    public func deserialize(json: JSON) -> NSDate {
        switch json {
        case .Str(let s):
            return self.dateFormatter.dateFromString(s)!
        default:
            fatalError("Type error deserializing")
        }
    }
}

// MARK: Model Serializers

extension User {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> User {
            switch json {
            case .Dictionary(let dict):
                let id = StringSerializer().deserialize(dict["id"] ?? .Null)
                let username = StringSerializer().deserialize(dict["username"] ?? .Null)
                let name = StringSerializer().deserialize(dict["name"] ?? .Null)
                return User(id: id, username: username, name: name)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
extension CuratedBatchesPage {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> CuratedBatchesPage {
            switch json {
            case .Array:
                let batches = ArraySerializer(CuratedBatch.Serializer()).deserialize(json)
                return CuratedBatchesPage(batches: batches)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
extension CuratedBatch {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> CuratedBatch {
            switch json {
            case .Dictionary(let dict):
                let id = UInt32Serializer().deserialize(dict["id"] ?? .Null)
                let publishedAt = NSDateSerializer().deserialize(dict["published_at"] ?? .Null)
                // FIXME: On the API documentation it says that a batch is supposed to have number
                // of downloads, but it's not provided!
                var downloads : UInt32 = 0
                if let d = dict["downloads"] {
                    downloads = UInt32Serializer().deserialize(d)
                }
                let curator = Curator.Serializer().deserialize(dict["curator"] ?? .Null)
                return CuratedBatch(id: id, publishedAt: publishedAt, downloads: downloads, curator: curator)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
extension CuratedBatchPhotosResult {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> CuratedBatchPhotosResult {
            switch json {
            case .Array:
                let photos = ArraySerializer(Photo.Serializer()).deserialize(json)
                return CuratedBatchPhotosResult(photos: photos)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
extension Curator {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> Curator {
            switch json {
            case .Dictionary(let dict):
                let id = StringSerializer().deserialize(dict["id"] ?? .Null)
                let username = StringSerializer().deserialize(dict["username"] ?? .Null)
                let name = StringSerializer().deserialize(dict["name"] ?? .Null)
                let bio = StringSerializer().deserialize(dict["bio"] ?? .Null)
                return Curator(id: id, username: username, name: name, bio: bio)
            default:
                fatalError("error deserializing")
            }
        }
    }    
}
extension Photo {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> Photo {
            switch json {
            case .Dictionary(let dict):
                let id = StringSerializer().deserialize(dict["id"] ?? .Null)
                let width = UInt32Serializer().deserialize(dict["width"] ?? .Null)
                let height = UInt32Serializer().deserialize(dict["height"] ?? .Null)
                let color = UIColorSerializer().deserialize(dict["color"] ?? .Null)
                let user = User.Serializer().deserialize(dict["user"] ?? .Null)
                let url = PhotoURL.Serializer().deserialize(dict["urls"] ?? .Null)
                return Photo(id: id, width: width, height: height, color: color, user: user, url: url)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
extension PhotoURL {
    public class Serializer : JSONSerializer {
        public init() {}
        public func deserialize(json: JSON) -> PhotoURL {
            switch json {
            case .Dictionary(let dict):
                let full = NSURLSerializer().deserialize(dict["full"] ?? .Null)
                let regular = NSURLSerializer().deserialize(dict["regular"] ?? .Null)
                let small = NSURLSerializer().deserialize(dict["small"] ?? .Null)
                let thumb = NSURLSerializer().deserialize(dict["thumb"] ?? .Null)
                return PhotoURL(full: full, regular: regular, small: small, thumb: thumb)
            default:
                fatalError("error deserializing")
            }
        }
    }
}
