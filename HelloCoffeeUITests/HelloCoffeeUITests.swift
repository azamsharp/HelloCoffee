//
//  HelloCoffeeUITests.swift
//  HelloCoffeeUITests
//
//  Created by Mohammad Azam on 8/18/22.
//

import XCTest
@testable import HelloCoffee


final class when_app_is_launched_with_no_orders: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
    }
    
    func test_should_make_sure_that_no_orders_message_is_displayed() {
        XCTAssertEqual("No orders available.", app.staticTexts["noOrdersText"].label)
    }
}

final class when_updating_an_existing_order: XCTestCase {
    
    private var app: XCUIApplication!
   // private var nameTextField: XCUIElement!
   // private var coffeeNameTextField: XCUIElement!
   // private var priceTextField: XCUIElement!
   // private var placeOrderButton: XCUIElement!
    
    override func setUp() {
        
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        // go to the add order screen
        app.buttons["addNewOrderButton"].tap()
        // write into textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 2.0)
        nameTextField.tap()
        nameTextField.typeText("Krammer")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 2.0)
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Hot Coffee")
        
        
        let _ = priceTextField.waitForExistence(timeout: 2.0)
        priceTextField.tap()
        priceTextField.typeText("4.50")
        
        // place the order
        placeOrderButton.tap()
    }
    
    func test_should_update_order_successfully() {
        
        // go to the order screen
        let orderList = app.collectionViews["orderList"]
        orderList.buttons["orderNameText-coffeeNameAndSizeText-coffeePriceText"].tap()
        
        app.buttons["editOrderButton"].tap()
        
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 5.0)
        nameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        nameTextField.typeText("Krammer Edit")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 15.0)
        coffeeNameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        coffeeNameTextField.typeText("Hot Coffee Edit")
        
        let _ = priceTextField.waitForExistence(timeout: 5.0)
        priceTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        priceTextField.typeText("1.50")
        
        placeOrderButton.tap()
        
        XCTAssertEqual("Hot Coffee Edit", app.staticTexts["coffeeNameText"].label)
        
    }
    
    // TEAR DOWN FUNCTIONS RUNS AND THEN DELETE ALL ORDERS FROM THE TEST DATABASE
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
}


final class when_deleting_an_order: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        // go to the add order screen
        app.buttons["addNewOrderButton"].tap()
        // write into textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Krammer")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Hot Coffee")
        
        priceTextField.tap()
        priceTextField.typeText("4.50")
        
        // place the order
        placeOrderButton.tap()
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cellsQuery = collectionViewsQuery.cells
        let element = cellsQuery.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeLeft()
        cellsQuery.children(matching: .other).element(boundBy: 2).children(matching: .other).element.swipeLeft()
        collectionViewsQuery.buttons["Delete"].tap()
    }
    
    func test_should_not_display_any_orders_on_the_screen() {
        let orderList = app.collectionViews["orderList"]
        XCTAssertEqual(0, orderList.cells.count)
    }
    
    // TEAR DOWN FUNCTIONS RUNS AND THEN DELETE ALL ORDERS FROM THE TEST DATABASE
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
}

final class when_adding_a_new_coffee_order: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        // go to the add order screen
        app.buttons["addNewOrderButton"].tap()
        // write into textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Krammer")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Hot Coffee")
        
        priceTextField.tap()
        priceTextField.typeText("4.50")
        
        // place the order
        placeOrderButton.tap()
    }
    
    func test_should_display_coffee_order_in_list_successfully() throws {
        XCTAssertEqual("Krammer", app.staticTexts["orderNameText"].label)
        XCTAssertEqual("Hot Coffee (Medium)", app.staticTexts["coffeeNameAndSizeText"].label)
        XCTAssertEqual(4.50.formatAsCurrency(), app.staticTexts["coffeePriceText"].label)
    }
    
    // TEAR DOWN FUNCTIONS RUNS AND THEN DELETE ALL ORDERS FROM THE TEST DATABASE
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
}
