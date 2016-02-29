// Models.swift
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

public class User {
    public let id : String
    public let username : String
    public let name : String
    
    public init(id: String, username: String, name: String) {
        self.id = id;
        self.username = username;
        self.name = name
    }
}
public class Curator {
    public let id : String
    public let username : String
    public let name : String
    public let bio : String
    
    public init(id: String, username: String, name: String, bio: String) {
        self.id = id;
        self.username = username;
        self.name = name
        self.bio = bio
    }
}
public class CuratedBatchesPage {
    public let batches : Array<CuratedBatch>
    
    public init(batches: Array<CuratedBatch>) {
        self.batches = batches
    }
}
public class CuratedBatch {
    public let id : UInt32
    public let publishedAt : NSDate
    public let downloads : UInt32
    public let curator : Curator
    
    public init(id: UInt32, publishedAt: NSDate, downloads: UInt32, curator: Curator) {
        self.id = id
        self.publishedAt = publishedAt
        self.downloads = downloads
        self.curator = curator
    }
}
public class PhotosResult {
    public let photos : Array<Photo>
    
    public init(photos: Array<Photo>) {
        self.photos = photos
    }
}
public class Photo {
    public let id : String
    public let width : UInt32
    public let height : UInt32
    public let color : UIColor
    public let user : User
    public let url : PhotoURL
    
    public init(id: String, width: UInt32, height: UInt32, color: UIColor, user: User, url: PhotoURL) {
        self.id = id
        self.width = width;
        self.height = height;
        self.color = color
        self.user = user
        self.url = url
    }
}
public class PhotoURL {
    public let full : NSURL
    public let regular : NSURL
    public let small : NSURL
    public let thumb : NSURL
    
    public init(full: NSURL, regular: NSURL, small: NSURL, thumb: NSURL) {
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}
public class CategoriesResult {
    public let categories : Array<Category>
    
    public init(categories: Array<Category>) {
        self.categories = categories
    }
}
public class Category {
    public let id : UInt32
    public let title : String
    public let photoCount : UInt32
    
    public init(id: UInt32, title: String, photoCount: UInt32) {
        self.id = id
        self.title = title
        self.photoCount = photoCount
    }
}
public class Stats {
    public let photoDownloads : UInt32
    public let batchDownloads : UInt32
    public init(photoDownloads: UInt32, batchDownloads: UInt32) {
        self.photoDownloads = photoDownloads
        self.batchDownloads = batchDownloads
    }
}
