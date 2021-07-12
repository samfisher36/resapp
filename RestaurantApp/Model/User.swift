//
//  User.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 08/06/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import Foundation


// MARK: - Previous Orders
struct PreviousOrders: Codable {
    
    var order_id: Int
    var grand_total: Float
    var timestamp: String
    var payment_type: String
    var user_name: String
    var amount_transferrable: Double
    var settlement_status: String
    var id: String
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case order_id = "oid"
        case grand_total = "grand_total"
        case timestamp = "timestamp"
        case payment_type = "payment_type"
        case user_name = "user_name"
        case amount_transferrable = "amount_transferrable"
        case settlement_status = "settlement_status"
    }
}


struct PreviousOrderItemList: Codable {
    let item_id: String
    let category: String
    let item_name: String
    let item_price: Float
    let available_jain: Bool
    let choosen_jain: Bool
    var quantity: Int
    var instructions: String
    let customisations: String
    let optionPrice: Double
    let taxable: Bool
    var item_type: String
    
    init(cartList: CartList) {
        self.item_id = cartList.getID()
        self.category = cartList.getCategory()
        self.item_name = cartList.getName()
        self.item_price = cartList.getPrice()
        self.available_jain = cartList.isJainAvailable()
        self.choosen_jain = cartList.isJainChoosen()
        self.quantity = cartList.getQuantity()
        self.instructions = cartList.getInstructions()
        self.customisations = cartList.getCustomisation()
        self.optionPrice = cartList.getOptionPrice()
        self.taxable = cartList.isTaxable()
        self.item_type = cartList.getItemType()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.item_name, forKey: .item_name)
        try container.encode(self.item_price, forKey: .item_price)
        try container.encode(self.available_jain, forKey: .available_jain)
        try container.encode(self.choosen_jain, forKey: .choosen_jain)
        try container.encode(self.quantity, forKey: .quantity)
        try container.encode(self.instructions, forKey: .instructions)
        try container.encode(self.customisations, forKey: .customisations)
        try container.encode(self.optionPrice, forKey: .optionPrice)
        try container.encode(self.taxable, forKey: .taxable)
        try container.encode(self.item_type, forKey: .item_type)
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case item_id = "_id"
        case category = "category"
        case item_name = "name"
        case item_price = "price"
        case available_jain = "isAvailableJain"
        case choosen_jain = "jain"
        case quantity = "quantity"
        case instructions = "instructions"
        case optionPrice = "optionPrice"
        case customisations = "customisation"
        case taxable = "taxable"
        case item_type = "item_type"
    }
}

//MARK: - Update Order

struct UpdateOrder: Codable {
    var order_id: String
    var items: [PreviousOrderItemList]
    
    init() {
        self.order_id = String()
        self.items = [PreviousOrderItemList]()
    }
    
    init(order_id: String, items: [PreviousOrderItemList]) {
        self.order_id = order_id
        self.items = items
    }
    
    private enum CodingKeys: String, CodingKey {
        case order_id = "order_id"
        case items = "items"
    }
}

