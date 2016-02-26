//
//  FlickrBrandTests.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/25/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import XCTest

class FlickrBrandTests: XCTestCase {
    
    var exampleBrand: FlickrBrand? = {
        if let brandJSONPath = NSBundle.mainBundle().pathForResource("flickr_brands", ofType: "json"),
            let data = NSData(contentsOfFile: brandJSONPath) {
                do {
                    guard let rawBrandsDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject],
                        let brandDictionaryArray = rawBrandsDictionary["brands"]?["brand" as NSString] as? [[String: AnyObject]] else {
                            XCTFail()
                            return .None
                    }
                    
                    guard let firstBrandDictionary = brandDictionaryArray.first else {
                        XCTFail()
                        return .None
                    }
                    guard let id = firstBrandDictionary["id"] as? String,
                        let name = firstBrandDictionary["name"] as? String else {
                            XCTFail()
                            return .None
                    }
                    let brand = FlickrBrand(id: id, name: name, rank: 1)
                    return brand
                }
                catch {
                    XCTFail()
                    return .None
                }
        }
        return .None
    }()
    
    func testInitialization() {
        XCTAssertNotNil(exampleBrand)
        if let brand = exampleBrand {
            XCTAssertEqual(brand.name, "Apple")
            XCTAssertEqual(brand.id, "apple")
            XCTAssertEqual(brand.rank, 1)
        }
    }
    
    func testCamerasURL() {
        XCTAssertNotNil(exampleBrand)
        guard let brandCameraURL = exampleBrand?.camerasURL,
            let cameraURLComponents = NSURLComponents(URL: brandCameraURL, resolvingAgainstBaseURL: true),
            let queryItems = cameraURLComponents.queryItems else {
                XCTFail()
                return
        }
        XCTAssertEqual(cameraURLComponents.host, "api.flickr.com")
        XCTAssertEqual(cameraURLComponents.path, "/services/rest/")
        XCTAssertTrue(queryItems.contains({$0.name == "method" && $0.value == "flickr.cameras.getBrandModels"}))
        XCTAssertTrue(queryItems.contains({$0.name == "brand" && $0.value == "apple"}))
        //            XCTAssertTrue(queryItems.contains({$0.name == "api_key" && $0.value == "did_not_say_the_magic_word"}))
        XCTAssertTrue(queryItems.contains({$0.name == "format" && $0.value == "json"}))
        XCTAssertTrue(queryItems.contains({$0.name == "nojsoncallback" && $0.value == "1"}))
    }
    
    func testFetchAllBrands() {
        let expectation = self.expectationWithDescription("Waiting for all brands")
        
        FlickrBrand.fetchAllBrands {
            [weak self]
            (optionalBrandArray, optionalError) -> Void in
            guard let brandArray = optionalBrandArray,
            let checkedSelf = self else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertNotNil(checkedSelf)
            XCTAssertEqual(brandArray.count, 42)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testFetchAllCameras() {
        guard let brand = exampleBrand else {
            XCTFail()
            return
        }
        
        let expectation = self.expectationWithDescription("Waiting for all cameras")
        brand.fetchCameras {
            (success, optionalError) -> Void in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
}
