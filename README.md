# UnsplashSwift

UnsplashSwift is a Swift framework to interact with the [Unsplash API](https://unsplash.com/developers).

__This framework is in heavy development and not ready for production yet.__

## Background

UnsplashSwift uses [Alamofire](https://github.com/Alamofire/Alamofire) as the backbone for API communication and OAuth authentication. The framework's architecture design is modeled heavily off of the way Dropbox implements their framework for Swift ([SwiffyDropbox](https://github.com/dropbox/SwiftyDropbox)).

- [API Documentation](https://unsplash.com/documentation)

## Features

- [ ] User Authorization
- [ ] User Profile
- [ ] Users
- [x] Photos (partial support)
- [x] Categories
- [x] Curated Batches
- [x] Stats

## Requirements

- iOS 9.0+
- Xcode 7.2+

## Communication

- If you __found a bug__, open an issue.
- If you __have a feature request__, open an issue.
- If you __want to contribute__, submit a pull request.

## Getting Started

If you don't have an application ID and secret, follow the steps from the [Unsplash API](https://unsplash.com/developers) to register a new application.

## Installation

Right now there is no support for Cocoapods or Carthage (support will be added as the framework develops).

## Usage

### Set Up

To start using the framework first set up the Unsplash client in your application's AppDelegate file.

```swift
import UIKit
import UnsplashSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Unsplash.setUpWithAppId("APP_ID", secret: "SECRET")

        return true
    }
}
```

__Make sure to replace ```APP_ID``` and ```SECRET``` with the application ID and secret you received when you created an application with the [Unsplash API](https://unsplash.com/developers).__

### Photos

#### Retrieve Photos

To retrieve photos, use ```findPhotos(page:perPage:)``` from the Unsplash client.
```swift
let client = Unsplash.client!
client.photos.findPhotos(2, perPage:nil).response({ response, error in
    if let result = response {
        print(result.photos)
    } else {
      // Handle error.
    }
})
```

#### Search Photos

To search for photos, use ```search(query:categoryIds:page:perPage:)``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.photos.search("cat").response({ response, error in
    if let result = response {
        print(result.photos)
    } else {
      // Handle error.
    }
})
```

#### Specific Photo

To retrieve a specific photo, use ```findPhoto(photoId:width:height:rect:)``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.photos.findPhoto("PHOTO_ID").response({ response, error in
    if let photo = response {
        print(photo.id)
    } else {
      // Handle error.
    }
})
```

#### Random Photo

To retrieve a random photo, use ```random(query:categoryIds:featured:username:width:height:)``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.photos.random().response({ response, error in
    if let photo = response {
        print(photo.id)
    } else {
      // Handle error.
    }
})
```

### Categories

#### All Categories

To retrieve all the categories, use ```all()``` from the Unsplash client.
```swift
let client = Unsplash.client!
client.categories.all().response({ response, error in
    if let result = response {
        print(result.categories)
    } else {
      // Handle error.
    }
})
```

#### Specific Category

To retrieve a specific curated batch, use ```findCategory(categoryId:)``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.categories.findCategory(2).response({ response, error in
    if let category = response {
        print(category.title)
    } else {
      // Handle error.
    }
})
```

The ```categories``` property, of the UnsplashClient, contains other methods as well (_CategoriesRoutes.swift_).

### Curated Batches

#### Latest Page

To retrieve the latest page of curated batches, use ```latestPage()``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.curatedBatches.latestPage().response({ response, error in
    if let page = response {
        print(page.batches)
    } else {
      // Handle error.
    }
})
```

#### Specific Batch

To retrieve a specific curated batch, use ```findBatch(batchId:)``` from the shared Unsplash client.
```swift
let client = Unsplash.client!
client.curatedBatches.findBatch(1).response({ response, error in
    if let batch = response {
        print(batch)
    } else {
      // Handle error.
    }
})
```

The ```curatedBatches``` property, of the UnsplashClient, contains other methods as well (_CuratedBatchesRoutes.swift_).

### Stats

#### Total Downloads

To retrieve the total number of downloads, use ```totalDownloads()``` from the Unsplash client.
```swift
let client = Unsplash.client!
client.stats.totalDownloads().response({ response, error in
    if let stats = response {
        print(stats.photoDownloads)
        print(stats.batchDownloads)
    } else {
      // Handle error.
    }
})
```

## Unit Tests

UnsplashSwift includes a set of unit tests to run on the framework. In order to run all the tests you need to fill the ```UNSPLASH_APP_ID``` and ```UNSPLASH_SECRET``` keys in the Test target's  *Info.plist*. If you don't fill these in the tests throw a fatal error when running.

__Note:__ If anyone has a better way of doing this so the file doesn't have to be modified everytime I'm open to suggestions.

## Contributors

- [Camden Fullmer](https://twitter.com/camdenfullmer)

## License

UnsplashSwift is released under the MIT license. See LICENSE for details.
