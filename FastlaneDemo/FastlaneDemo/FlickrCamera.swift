//
//  FlickrCamera.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/23/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

public class FlickrCamera: NSObject {
    
    var id = ""
    var name = ""
    var smallImageURL: NSURL?
    var largeImageURL: NSURL?
    
    init(id: String, name: String, smallImageURL: NSURL?, largeImageURL: NSURL?) {
        self.id = id
        self.name = name
        self.smallImageURL = smallImageURL
        self.largeImageURL = largeImageURL
        super.init()
    }
    
    internal class func createCameraArray(data: NSData) -> [FlickrCamera] {
        var returnCameraArray = [FlickrCamera]()
        do {
            let rawJsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options:[])
            guard let allCamerasDictionary = rawJsonDictionary["cameras" as NSString] as? [String: AnyObject],
                let cameraDictionaryArray = allCamerasDictionary["camera"] as? [[String: AnyObject]] else {
                    return returnCameraArray
            }
            for cameraDictionary in cameraDictionaryArray {
                guard let id = cameraDictionary["id"] as? String,
                    let name = cameraDictionary["name"]?["_content" as NSString] as? String else {
                        return returnCameraArray
                }
                
                var optionalSmallImageURL: NSURL? = .None
                var optionalLargeImageURL: NSURL? = .None
                
                if let imageDictionary = cameraDictionary["images"] as? [String: AnyObject] {
                    if let smallImageURLString = imageDictionary["small"]?["_content" as NSString] as? String,
                        let smallImageURL = NSURL(string: smallImageURLString) {
                            optionalSmallImageURL = smallImageURL
                    }
                    
                    if let largeImageURLString = imageDictionary["large"]?["_content" as NSString] as? String,
                        let largeImageURL = NSURL(string: largeImageURLString) {
                            optionalLargeImageURL = largeImageURL
                    }
                }
                
                let camera = FlickrCamera(id: id, name: name, smallImageURL: optionalSmallImageURL, largeImageURL: optionalLargeImageURL)
                returnCameraArray.append(camera)
            }
            return returnCameraArray
        }
        catch {
            return returnCameraArray
        }
    }
}

/*
{
    "id": "iphone_6",
    "name": {
        "_content": "Apple iPhone 6"
    },
    "images": {
        "small": {
            "_content": "https://farm6.staticflickr.com/5616/cameras/72157626544376501_model_small_280e5c0d46.jpg"
        },
        "large": {
            "_content": "https://farm6.staticflickr.com/5616/cameras/72157626544376501_model_large_69e7e5cfc6.jpg"
        }
    }
},
*/