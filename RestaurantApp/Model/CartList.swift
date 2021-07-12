//
//  Order.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 26/02/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import Foundation

class CartList: Codable {
    
    private var id = String()
    private var name = String()
    private var price = Float()
    private var quantity = 0
    private var instructions = String()
    private var available_jain = Bool()
    private var choosen_jain = Bool()
    private var optionPrice = Double()
    private var customisation = String()
    private var category = String()
    private var hasCustomisation: Bool = false
    private var hasDiscount = Bool()
    private var discount_value = Double()
    
    private var item_type = String()
    private var taxable = Bool()
    private var status: Bool = false
    
    public init () {
    }

//    public init(name: String, price: String, quantity:Int, jain: Int) {
//        self.name = name
//        self.price = price
//        self.quantity = quantity
//        self.choosen_jain = jain
//    }
//
//    public init(name: String, price: String, jain: Int, quantity: Int, instructions: String) {
//        self.name = name
//        self.price = price
//        self.choosen_jain = jain
//        self.quantity = quantity
//        self.instructions = instructions
//
//
//    }
    public init(
        id: String,
        name: String,
        price: Float,
        available_jain: Bool,
        choosen_jain: Bool,
        quantity: Int,
        instructions: String,
        optionPrice: Double,
        customisation: String,
        category: String,
        hasCustomisation: Bool,
        hasDiscount: Bool,
        discount_value: Double,
        item_type: String,
        taxable: Bool,
        status: Bool) {
        
        self.id = id
        self.name = name
        self.price = price
        self.available_jain = available_jain
        self.choosen_jain = choosen_jain
        self.quantity = quantity
        self.instructions = instructions
        self.optionPrice = optionPrice
        self.customisation = customisation
        self.category = category
        self.hasCustomisation = hasCustomisation
        self.hasDiscount = hasDiscount
        self.discount_value = discount_value
        self.item_type = item_type
        self.taxable = taxable
        self.status = status
    }
    
    public init(cart: PreviousOrderItemList, discount_value: Double, status: Bool) {
        self.id = cart.item_id
        self.name = cart.item_name
        self.price = cart.item_price
        self.available_jain = cart.available_jain
        self.choosen_jain = cart.choosen_jain
        self.quantity = cart.quantity
        self.instructions = cart.instructions
        self.optionPrice = Double(cart.optionPrice)
        self.customisation = cart.customisations
        self.category = cart.category
        if(cart.customisations != "" || cart.customisations != " ") {
            self.hasCustomisation = true
        } else {
            self.hasCustomisation = false
        }
        
        if(discount_value > 0) {
            self.hasDiscount = true
        } else {
            self.hasDiscount = false
        }
        self.discount_value = discount_value
        self.item_type = cart.item_type
        self.taxable = cart.taxable
        self.status = status
    }

    public func getID() -> String {
        return id
    }

    public func set(id: String) {
        self.id = id
    }
    
    public func getName() -> String {
        return name
    }

    public func set(name: String) {
        self.name = name
    }

    public func getPrice() -> Float {
        return price
    }

    public func set(price: Float) {
        self.price = price
    }
    
//    public func getDescription() -> String {
//        return description
//    }
//
//    public func set(description: String) {
//        self.description = description
//    }

    public func getQuantity() -> Int {
        return quantity
    }

    public func set(quantity: Int) {
        self.quantity = quantity
    }

    public func getInstructions() -> String {
        return instructions
    }

    public func set(instructions: String) {
        self.instructions = instructions
    }
    
    public func isJainAvailable() -> Bool {
        return available_jain
    }

    public func set(jain_available: Bool) {
        self.available_jain = jain_available
    }
    
    public func isJainChoosen() -> Bool {
        return choosen_jain
    }

    public func set(jain_choosen: Bool) {
        self.choosen_jain = jain_choosen
    }
    
    public func getOptionPrice() -> Double {
        return optionPrice
    }

    public func set(optionPrice: Double) {
        self.optionPrice = optionPrice
    }
    
    public func getCustomisation() -> String {
        return customisation
    }

    public func set(customisation: String) {
        self.customisation = customisation
    }
    
    func getCategory() -> String {
        return self.category
    }

    public func set(category: String) {
        self.category = category
    }

    public func isHasCustomisation() -> Bool {
        return hasCustomisation
    }

    public func set(hasCustomisation: Bool) {
        self.hasCustomisation = hasCustomisation
    }
    
    public func ishasDiscount() -> Bool {
        
        return hasDiscount
    }
    
    public func set(hasDiscount: Bool) {
        self.hasDiscount = hasDiscount
    }
    
    public func discountValue() -> Double {
        return self.discount_value
    }
    
    public func set(discount_value: Double) {
        self.discount_value = discount_value
    }
    
    public func set(taxable: Bool) {
        self.taxable = taxable
    }
    
    public func isTaxable() -> Bool {
        return self.taxable
    }

    public func setItemType(item_type: String) {
        self.item_type = item_type
    }
    
    public func getItemType() -> String {
        return self.item_type
    }
    
    public func set(status: Bool) {
        self.status = status
    }
    
    public func getStatus() -> Bool {
        return self.status
    }
}
