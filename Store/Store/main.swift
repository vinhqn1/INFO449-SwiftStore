//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

@objc protocol SKU  {
    var name : String { get }
    var priceEach : Int { get set }
    func price() -> Int
    @objc optional func toString() -> String
}


class Item : NSObject, SKU {
    var name : String
    var weight : Double? = nil
    var priceEach : Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    init(name: String, priceEach: Int, weight: Double) {
        self.name = name
        self.priceEach = priceEach
        self.weight = weight
    }
    
    // If the calculated price of an item results in fractions of a penny, round using normal rounding rules (Round up >= .5, Round down < .5)
    func price() -> Int {
        if weight != nil {
            return Int((Double(priceEach) * weight!).rounded())
        } else {
            return priceEach
        }
    }
}


class Receipt {
    private var itemList : [SKU] = []
    var totalCost : Int?
    
    func addItem(_ sku: SKU) {
        itemList.append(sku)
    }
    
    func items() -> [SKU] {
        return itemList
    }
    
    private func priceToString(_ price: Int) -> String {
        let priceString : String = "$\(price / 100).\(price % 100)"
        return "\(priceString)"
    }
    
    func output() -> String {
        var output = "Receipt:\n"
        for item in itemList {
            output += "\(item.name): \(priceToString(item.price()))\n"
        }
        output += """
        ------------------
        TOTAL: \(priceToString(totalCost!))
        """
        return output
    }
    
    func total() -> Int? {
        if totalCost != nil {
            return totalCost!
        } else {
            return nil
        }
    }
}

// COUPONS ARE APPLIED BEFORE TAX
class Coupon {
    var itemName : String
    var discount : Double = 0.15
    
    init (_ itemName: String) {
        self.itemName = itemName
    }
    
    init (_ itemName: String, _ discount: Double) {
        self.itemName = itemName
        self.discount = discount
    }
}

class Register {
    
    private var currentReceipt : Receipt = Receipt()
    private var coupons : [Coupon] = []

    func scan(_ sku: SKU) {
        currentReceipt.addItem(sku)
    }
    
    func scanCoupon(_ coupon: Coupon) {
        coupons.append(coupon)
    }
    
    func applyCoupons() {
    }
    
//  SUBTOTAL REFERS TO THE PRICE OF GOODS WHICH INCLUDES DISCOUNTS/COUPONS
//  TAX NOT INCLUDED IN SUBTOTAL
    func subtotal() -> Int {
        var sum = 0
        var usedCouponIndices : [Int] = []
        for item in currentReceipt.items() {
            sum += item.price()
            for (index, coupon) in coupons.enumerated() {
                if coupon.itemName == item.name && !usedCouponIndices.contains(index) {
                    sum -= Int((Double(item.price()) * coupon.discount).rounded())
                    usedCouponIndices.append(index)
                    break
                }
            }
        }
        return sum
    }
    
    private func finalSubtotal() -> Int {
        var sum = 0
        var usedCouponIndices : [Int] = []
        for item in currentReceipt.items() {
            sum += item.price()
            for (index, coupon) in coupons.enumerated() {
                if coupon.itemName == item.name && !usedCouponIndices.contains(index) {
                    sum -= Int((Double(item.price()) * coupon.discount).rounded())
                    usedCouponIndices.append(index)
                    break
                }
            }
        }
        usedCouponIndices.sort(by: >)
        for usedCouponIndex in usedCouponIndices {
            coupons.remove(at: usedCouponIndex)
        }
        return sum
    }
    
//  TOTAL REFERS TO THE ORDER TOTAL WHICH INCLUDES THINGS LIKE TAX, SHIPPING, FEES, TIPS, ETC
    func total() -> Receipt {
        currentReceipt.totalCost = finalSubtotal()
        
        let orderReceipt = currentReceipt
        currentReceipt = Receipt()
        return orderReceipt
    }
}



class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

