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
        setupSnapshot(app)
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
        sleep(2)
        snapshot("Screen1", waitForLoadingIndicator: false)
        XCUIApplication().tables.staticTexts["Apple"].tap()
        XCTAssertNotNil(XCUIApplication().tables.staticTexts["iPhone 6s"])
        sleep(2)
        snapshot("Screen2", waitForLoadingIndicator: false)
        let app = XCUIApplication()
        app.tables.staticTexts["Apple iPhone 6"].tap()
        XCTAssertNotNil(app.staticTexts["Apple"])
        XCTAssertNotNil(app.staticTexts["Apple iPhone 6"])
        sleep(2)
        snapshot("Screen3", waitForLoadingIndicator: false)
    }
    
}
