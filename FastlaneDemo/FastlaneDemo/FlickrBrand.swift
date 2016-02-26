//
//  FlickrBrand.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/22/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

public class FlickrBrand: NSObject {
    
    public var id = ""
    public var name = ""
    public var rank = 0
    public var cameras = [FlickrCamera]()
    
    private static var isTesting: Bool {
        get {
            let environment = NSProcessInfo.processInfo().environment
            let bundleInjection = environment["XCInjectBundle"] as NSString?
            return ((environment["isUITest"] != nil) || (bundleInjection?.pathExtension == "xctest"))
        }
    }
    
    public static var fetchURL: NSURL? = {
        guard let secretPath = NSBundle.mainBundle().pathForResource("flickr", ofType: "secret") else { return .None }
        
        do {
            let completeString = try NSString(contentsOfFile: secretPath, encoding: NSUTF8StringEncoding)
            let stringsArray = completeString.componentsSeparatedByString("\n")
            
            guard let key = stringsArray.first,
                let components = NSURLComponents(string: "https://api.flickr.com") else { return .None }
            
            
            components.path = "/services/rest/"
            components.queryItems = [NSURLQueryItem(name: "method", value: "flickr.cameras.getBrands"),
                NSURLQueryItem(name: "api_key", value: key),
                NSURLQueryItem(name: "format", value: "json"),
                NSURLQueryItem(name: "nojsoncallback", value: "1")]
            
            if let url = components.URL {
                return url
            }
        }
        catch {
            return .None
        }
        return .None
    }()
    
    public var camerasURL: NSURL? {
        get {
            guard let secretPath = NSBundle.mainBundle().pathForResource("flickr", ofType: "secret") else { return .None }
            
            do {
                let completeString = try NSString(contentsOfFile: secretPath, encoding: NSUTF8StringEncoding)
                let stringsArray = completeString.componentsSeparatedByString("\n")
                
                guard let key = stringsArray.first,
                    let components = NSURLComponents(string: "https://api.flickr.com") else { return .None }
                
                
                components.path = "/services/rest/"
                components.queryItems = [NSURLQueryItem(name: "method", value: "flickr.cameras.getBrandModels"),
                    NSURLQueryItem(name: "brand", value: id),
                    NSURLQueryItem(name: "api_key", value: key),
                    NSURLQueryItem(name: "format", value: "json"),
                    NSURLQueryItem(name: "nojsoncallback", value: "1")]
                
                if let url = components.URL {
                    return url
                }
            }
            catch {
                return .None
            }
            return .None
        }
    }
    
    public init(id: String, name: String, rank: Int) {
        self.id = id
        self.name = name
        self.rank = rank
        super.init()
    }
    
    public class func fetchAllBrands(completion: ([FlickrBrand]?, NSError?) -> Void) {
        let loadBrandsClosure = {
            (data: NSData, completion: ([FlickrBrand]?, NSError?) -> Void) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                do {
                    guard let rawDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject],
                        let brandDictionaryArray = rawDictionary["brands"]?["brand" as NSString] as? [[String: AnyObject]] else {
                            completion(.None, .None)
                            return
                    }
                    
                    var rank = 0
                    var brandArray = [FlickrBrand]()
                    for brandDictionary in brandDictionaryArray {
                        rank += 1
                        guard let id = brandDictionary["id"] as? String,
                            let name = brandDictionary["name"] as? String else {
                                completion(.None, .None)
                                return
                        }
                        let brand = FlickrBrand(id: id, name: name, rank: rank)
                        brandArray.append(brand)
                    }
                    completion(brandArray, .None)
                }
                catch {
                    completion(.None, .None)
                    return
                }                
            })
        }
        
        if isTesting {
            guard let brandJSONPath = NSBundle.mainBundle().pathForResource("flickr_brands", ofType: "json"),
                let data = NSData(contentsOfFile: brandJSONPath) else {
                    completion(.None, .None)
                    return
            }
            
            loadBrandsClosure(data, completion)
        }
        else {
            guard let brandFetchURL = FlickrBrand.fetchURL else {
                completion(.None, .None)
                return
            }
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(brandFetchURL) {
                (optionalData, _, optionalError) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    () -> Void in
                    guard let data = optionalData else {
                        completion(.None, .None)
                        return
                    }
                    
                    loadBrandsClosure(data, completion)
                })
            }
            
            task.resume()
        }
    }
    
    public func fetchCameras(completion: (Bool, NSError?) -> Void) {
        if cameras.count > 0 {
            completion(true, .None)
            return
        }
        
        let loadCamerasClosure = {
            [weak self]
            (data: NSData, completion: (Bool, NSError?) -> Void) in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                guard let checkedSelf = self else { return }
                checkedSelf.cameras = FlickrCamera.createCameraArray(data)
                if checkedSelf.cameras.count > 0 {
                    completion(true, nil)
                }
                else {
                    completion(false, .None)
                    return
                }
            })
        }
        
        if FlickrBrand.isTesting {
            guard let brandJSONPath = NSBundle.mainBundle().pathForResource("flickr_brand_camera_apple", ofType: "json"),
                let data = NSData(contentsOfFile: brandJSONPath) else {
                    completion(false, .None)
                    return
            }
            
            loadCamerasClosure(data, completion)
        }
        else {
            if let brandCamerasURL = self.camerasURL {
                NSURLSession.sharedSession().dataTaskWithURL(brandCamerasURL, completionHandler: {
                    (optionalData, optionalResponse, optionalError) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        guard let data = optionalData else {
                            completion(false, optionalError)
                            return
                        }
                        
                        loadCamerasClosure(data, completion)
                    })
                }).resume()
            }
            else {
                completion(false, nil)
            }
        }
    }
    
    private func addCamera(camera: FlickrCamera) {
        self.cameras.append(camera)
    }
}
