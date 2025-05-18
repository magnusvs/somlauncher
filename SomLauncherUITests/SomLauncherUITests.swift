//
//  SomLauncherUITests.swift
//  SomLauncherUITests
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import XCTest

final class SomLauncherUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
    
    func testAppSheetAccessButtonTriggersOpenPanelWithoutFreezing() {
        // Given: The app is launched in UI test mode
        let app = launchCleanApplication()
        navigateOnboarding(app: app)

        // And: The user has added a new item
        app.buttons["Add item"].tap()

        // When: The user opens the app selection sheet and taps "Allow access"
        app.buttons["Select app"].tap()
        app.buttons["Allow access"].tap()

        // Then: The app remains running in the foreground
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "App may have crashed or frozen")

        // And: The NSOpenPanel dialog appears
        let openPanel = app.dialogs.element(boundBy: 0)
        XCTAssertTrue(openPanel.waitForExistence(timeout: 5), "NSOpenPanel did not appear — app may have frozen or failed to show dialog")
    }
    
    func navigateOnboarding(app: XCUIApplication) {
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.staticTexts["SomLauncher options"].waitForExistence(timeout: 2))
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.staticTexts["You're all set!"].waitForExistence(timeout: 2))
        app.buttons["Create first launcher"].tap()
        XCTAssertTrue(app.staticTexts["Build your launcher"].waitForExistence(timeout: 2))
    }
    
    func launchCleanApplication() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("--reset-userdefaults")
        app.launch()
        return app
    }
}
