//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        print(receipt.output())
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
//  MY TESTS
    func testOneItemSubtotal() {
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        XCTAssertEqual(299, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(299, receipt.total())
    }
// WEIGHTED ITEMS
// If the calculated price of an item results in fractions of a penny, round using normal rounding rules (Round up >= .5, Round down < .5)
    func testOneWeightedItem() {
        register.scan(Item(name: "Ribeye Steak", priceEach: 999, weight: 1.1))
        XCTAssertEqual(1099, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1099, receipt.total())
    }
    
    func testMultipleMixedItems() {
        register.scan(Item(name: "Ribeye Steak", priceEach: 999, weight: 1.1))
        XCTAssertEqual(1099, register.subtotal())
        register.scan(Item(name: "Bananas", priceEach: 69, weight: 2.4))
        XCTAssertEqual(1265, register.subtotal())
        register.scan(Item(name: "Apples", priceEach: 59, weight: 3.01))
        XCTAssertEqual(1443, register.subtotal())
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        XCTAssertEqual(1742, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1742, receipt.total())
    }
    
    func testCoupon() {
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        register.scan(Item(name: "Doritos (16oz Bag)", priceEach: 1049))
        register.scanCoupon(Coupon("Cheetos (8oz Bag)"))
        XCTAssertEqual(1303, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1303, receipt.total())
    }
    
    func testCustomCoupon() {
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        register.scan(Item(name: "Doritos (16oz Bag)", priceEach: 1049))
        register.scanCoupon(Coupon("Cheetos (8oz Bag)"))
        register.scanCoupon(Coupon("Doritos (16oz Bag)", 0.2))
        XCTAssertEqual(1093, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1093, receipt.total())
    }
    
    func testCouponSameItem() {
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        register.scan(Item(name: "Cheetos (8oz Bag)", priceEach: 299))
        register.scanCoupon(Coupon("Cheetos (8oz Bag)"))
        XCTAssertEqual(553, register.subtotal())
        register.scanCoupon(Coupon("Cheetos (8oz Bag)"))
        let receipt = register.total()
        XCTAssertEqual(508, receipt.total())
        
    }
}
