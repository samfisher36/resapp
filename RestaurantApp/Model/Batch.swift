//
//  Models.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit

struct Batch: Codable {
    var items: [Item]
    var status: String
    var timestamp: String
    var id: String
              
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        items = try values.decode([Item].self, forKey: .items)
        status = try values.decode(String.self, forKey: .status)
        timestamp = try values.decode(String.self, forKey: .timestamp)
        id = try values.decode(String.self, forKey: .id)
        
    }
 
    private enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case items = "items"
        case timestamp = "timestamp"
        case id = "_id"
    
    }
    
    init() {
        self.items = [Item()]
        self.status = String()
        self.timestamp = String()
        self.id = String()
    }
    
}
