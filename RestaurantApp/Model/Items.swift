//
//  Models.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit

struct Item: Codable {
    var id: String
    var category: String
    var customisation: String
    var instructions: String
    let isAvailableJain : Bool
    var item_type: String
    
    var jain: Bool
    var name: String
    var optionPrice: Float
    
    var price: Float
    var quantity: Int
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        
        name = try values.decode(String.self, forKey: .name)
        
        category = try values.decode(String.self, forKey: .category)
        customisation = try values.decode(String.self, forKey: .customisation)
        instructions = try values.decode(String.self, forKey: .instructions)
        
        isAvailableJain = try values.decodeIfPresent(Bool.self, forKey: .isAvailableJain) ?? false
        
        jain = try values.decodeIfPresent(Bool.self, forKey: .jain) ?? false
        
        item_type = try values.decode(String.self, forKey: .item_type)
        
        price = try values.decodeIfPresent(Float.self, forKey: .price) ?? 0.0
        
        optionPrice = try values.decodeIfPresent(Float.self, forKey: .optionPrice) ?? 0.0
        
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        
        
        
    }
 
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case category = "category"
        case customisation = "customisation"
        case instructions = "instructions"
        case isAvailableJain = "isAvailableJain"
        case item_type = "item_type"
        case jain = "jain"
        
        case name = "name"
        case optionPrice = "optionPrice"
        case price = "price"
        case quantity = "quantity"
        
    }
    
    init() {
        self.id = String()
        self.category = String()
        self.customisation = String()
        self.instructions = String()
        self.isAvailableJain = Bool()
        self.item_type = String()
        self.jain = Bool()
        self.name = String()
        self.optionPrice = Float()
        self.price = Float()
        self.quantity = Int()
        
        
    }
    
    
    
}

