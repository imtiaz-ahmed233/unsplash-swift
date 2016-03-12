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
    public let id : String?
    public let username : String
    public let name : String?
    public let firstName : String?
    public let lastName : String?
    public let downloads : UInt32?
    public let profilePhoto : ProfilePhotoURL?
    public let portfolioURL : NSURL?
    public let bio : String?
    public let uploadsRemaining : UInt32?
    public let instagramUsername : String?
    public let location : String?
    public let email : String?
    
    public init(
        id: String?, username: String, name: String?, firstName: String?, lastName: String?, downloads: UInt32?, profilePhoto: ProfilePhotoURL?, portfolioURL: NSURL?, bio : String?, uploadsRemaining: UInt32?, instagramUsername : String?, location : String?, email : String?) {
        self.id = id;
        self.username = username;
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.downloads = downloads
        self.profilePhoto = profilePhoto
        self.portfolioURL = portfolioURL
        self.bio = bio
        self.uploadsRemaining = uploadsRemaining
        self.instagramUsername = instagramUsername
        self.location = location
        self.email = email
    }
}
public class ProfilePhotoURL {
    public let large : NSURL
    public let medium : NSURL
    public let small : NSURL
    public let custom : NSURL?
    
    public init(large: NSURL, medium: NSURL, small: NSURL, custom: NSURL?) {
        self.large = large
        self.medium = medium
        self.small = small
        self.custom = custom
    }
}
public class CollectionsResult {
    public let collections : Array<Collection>
    
    public init(collections: Array<Collection>) {
        self.collections = collections
    }
}
public class Collection {
    public let id : UInt32
    public let title : String
    public let curated : Bool
    public let coverPhoto : Photo
    public let publishedAt : NSDate
    public let user : User
    
    public init(id: UInt32, title: String, curated: Bool, coverPhoto: Photo, publishedAt: NSDate, user: User) {
        self.id = id
        self.publishedAt = publishedAt
        self.user = user
        self.title = title
        self.curated = curated
        self.coverPhoto = coverPhoto
    }
}
public class PhotoCollectionResult {
    public let photo : Photo
    public let collection : Collection
    
    public init(photo: Photo, collection: Collection) {
        self.photo = photo
        self.collection = collection
    }
}
public class PhotoUserResult {
    public let photo : Photo
    public let user : User

    public init(photo: Photo, user: User) {
        self.photo = photo
        self.user = user
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
    public let width : UInt32?
    public let height : UInt32?
    public let color : UIColor?
    public let user : User?
    public let url : PhotoURL
    public let categories : Array<Category>?
    public let exif : Exif?
    public let downloads : UInt32?
    public let likes : UInt32?
    public let location : Location?
    
    public init(id: String, width: UInt32?, height: UInt32?, color: UIColor?, user: User?, url: PhotoURL, categories: Array<Category>?, exif: Exif?, downloads: UInt32?, likes: UInt32?, location: Location?) {
        self.id = id
        self.width = width;
        self.height = height;
        self.color = color
        self.user = user
        self.url = url
        self.categories = categories
        self.exif = exif
        self.downloads = downloads
        self.likes = likes
        self.location = location
    }
}
public class PhotoURL {
    public let full : NSURL
    public let regular : NSURL
    public let small : NSURL
    public let thumb : NSURL
    public let custom : NSURL?
    
    public init(full: NSURL, regular: NSURL, small: NSURL, thumb: NSURL, custom: NSURL?) {
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
        self.custom = custom
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
public class Exif {
    public let make : String?
    public let model : String?
    public let exposureTime : Double?
    public let aperture : Double?
    public let focalLength : UInt32?
    public let iso : UInt32?
    public init(make: String?, model: String?, exposureTime: Double?, aperture: Double?, focalLength: UInt32?, iso: UInt32?) {
        self.make = make
        self.model = model
        self.exposureTime = exposureTime
        self.aperture = aperture
        self.focalLength = focalLength
        self.iso = iso
    }
}
public class Location {
    public let city: String?
    public let country: String?
    public let positon: Position?
    public let name : String?
    public let confidential : Bool?
    public init(city: String?=nil, country: String?=nil, position: Position?=nil, name: String?=nil, confidential: Bool?=nil) {
        self.city = city
        self.country = country
        self.positon = position
        self.name = name
        self.confidential = confidential
    }
}
public class Position {
    public let latitude : Double
    public let longitude : Double
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
