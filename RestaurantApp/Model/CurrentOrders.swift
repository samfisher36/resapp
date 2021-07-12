//
//  Models.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit

struct CurrentOrders: Codable {
    var id: String
    var batch: [Batch]
    var status: String
    var table_id: Int
    var user_id: String
    var Fcm_id: String
    var user_name: String
    var user_email: String
    var user_phone: String
    var payment_otp: Int
    
    //for bill
    var sub_total : Float
    var net_total : Float
    var cgst : Float
    var sgst : Float
    var service_charge : Float
    var grand_total : Float
    var discount : Float
    
    var coupon_discount:Float
    var coupon_code:String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        batch = try values.decodeIfPresent([Batch].self, forKey: .batch) ?? [Batch()]
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        table_id = try values.decodeIfPresent(Int.self, forKey: .table_id) ?? 0
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id) ?? ""
        Fcm_id = try values.decodeIfPresent(String.self, forKey: .Fcm_id) ?? ""
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name) ?? ""
        user_phone = try values.decodeIfPresent(String.self, forKey: .user_phone) ?? ""
        user_email = try values.decodeIfPresent(String.self, forKey: .user_email) ?? ""
        
        
        //for bill
        sub_total = try values.decodeIfPresent(Float.self, forKey: .sub_total) ?? 0.0
        net_total = try values.decodeIfPresent(Float.self, forKey: .net_total) ?? 0.0
        cgst = try values.decodeIfPresent(Float.self, forKey: .cgst) ?? 0.0
        sgst = try values.decodeIfPresent(Float.self, forKey: .sgst) ?? 0.0
        grand_total = try values.decodeIfPresent(Float.self, forKey: .grand_total) ?? 0.0
        service_charge = try values.decodeIfPresent(Float.self, forKey: .service_charge) ?? 0.0
        discount = try values.decodeIfPresent(Float.self, forKey: .discount) ?? 0.0
        
        payment_otp = try values.decodeIfPresent(Int.self, forKey: .payment_otp) ?? 0
        
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code) ?? ""
        
        coupon_discount = try values.decodeIfPresent(Float.self, forKey: .coupon_discount) ?? 0

    }
 
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case batch = "batch"
        case status = "status"
        case table_id = "table_id"
        
        case user_id = "user_id"
        case Fcm_id = "Fcm_id"
        case user_name = "user_name"
        case user_email = "user_email"
        
        case user_phone = "user_phone"
        case payment_otp = "payment_otp"
        
        
        //For bill
        case sub_total = "sub_total"
        case net_total = "net_total"
        case cgst = "cgst"
        case sgst = "sgst"
        case grand_total = "grand_total"
        case service_charge = "service_charge"
        case discount = "total_discount"
        
        case coupon_discount = "coupon_discount"
        case coupon_code = "coupon_code"
        
    }
    
    init() {
        
        self.id = String()
        self.batch = [Batch()]
        self.status = String()
        self.table_id = Int()
        self.user_id = String()
        self.Fcm_id = String()
        self.user_name = String()
        
        self.user_email = String()
        self.user_phone = String()
        
        //for bill
        self.sub_total = Float()
        self.net_total = Float()
        self.cgst = Float()
        self.sgst = Float()
        self.grand_total = Float()
        self.service_charge = Float()
        self.discount = Float()
        
        
        self.payment_otp = Int()
        
        self.coupon_code = String()
        self.coupon_discount = Float()
       
    }
    
    
}

