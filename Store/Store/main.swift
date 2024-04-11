//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

@objc protocol SKU  {
    var name : String { get }
    func price() -> Int
    @objc optional func toString() -> String
}


class Item : NSObject, SKU {
    var name : String
    var weight : Double? = nil
    private var priceEach : Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    init(name: String, priceEach: Int, weight: Double) {
        self.name = name
        self.priceEach = priceEach
        self.weight = weight
    }
    
    func price() -> Int {
        if weight != nil {
            return Int(Double(priceEach) * weight!)
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

class Register {
    private var currentReceipt : Receipt
    
    init() {
        currentReceipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        currentReceipt.addItem(sku)
    }
    
    func subtotal() -> Int {
        var sum = 0
        for item in currentReceipt.items() {
            sum += item.price()
        }
        return sum
    }
    
    func total() -> Receipt {
        currentReceipt.totalCost = subtotal()
//        2-1, coupons, tax, grouped
        
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

