//
//  FastlaneDemoUITests.swift
//  FastlaneDemoUITests
//
//  Created by mrJacob on 2/7/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import XCTest

class FastlaneDemoUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = ["isUITest": "YES"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBrandToCamera() {
        XCUIApplication().tables.staticTexts["Apple"].tap()
        XCTAssertNotNil(XCUIApplication().tables.staticTexts["iPhone 6s"])
    }
    
    func testCameraToDetail() {
        testBrandToCamera()
        let app = XCUIApplication()
        app.tables.staticTexts["Apple iPhone 6"].tap()
        XCTAssertNotNil(app.staticTexts["Apple"])
        XCTAssertNotNil(app.staticTexts["Apple iPhone 6"])
        
    }
    
}
