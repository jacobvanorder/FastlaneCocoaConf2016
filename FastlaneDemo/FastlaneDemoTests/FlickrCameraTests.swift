//
//  FlickrCameraTests.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/26/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import XCTest

class FlickrCameraTests: XCTestCase {
    
    func testCreateBrandCameraArray() {
        guard let brandJSONPath = NSBundle.mainBundle().pathForResource("flickr_brand_camera_apple", ofType: "json"),
            let data = NSData(contentsOfFile: brandJSONPath) else {
                XCTFail()
                return
        }
        let cameras = FlickrCamera.createCameraArray(data)
        XCTAssertNotNil(cameras)
        XCTAssertTrue(cameras.count > 0)
    }
    
    
}
