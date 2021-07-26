//
//  Constant.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 25/01/20.
//  Copyright © 2020 peAR Technologies. All rights reser    ved.
//

import UIKit

class Constant: NSObject {
 
    //static private let DOMAIN_NAME = "https://backend.pearpartner.com/"
    
    static private let DOMAIN_NAME = "https://staging.pearpartner.com/"
    
    
    //MARK: - URLs
    struct URL {
        
        //static let TRIAL: String
        //    = DOMAIN_NAME + "restaurant/9999"
        
        
        static let SEND_VER: String
            = DOMAIN_NAME + "user/update_app_version"
        
        static let LEADERBOARD: String
            = DOMAIN_NAME + "analytics/restaurant/NPDleaderboard/"
        
        static let LOGIN: String
            = DOMAIN_NAME + "login"
   
        static let CURRENT_ORDER: String
            = DOMAIN_NAME + "mobile/currentorders/"
        
        static let FCM_UPDTAE: String
            = DOMAIN_NAME + "mobile/updatefcm/"
        
        static let ACCEPT_ORDER: String
            = DOMAIN_NAME + "mobile/acceptorder/"
        
        static let GENERATE_BILL: String
            = DOMAIN_NAME + "mobile/generatebill/"
        
        static let CANCEL_ITEM: String
            = DOMAIN_NAME + "mobile/cancelitem/"
        
        static let CANCEL_BATCH: String
            = DOMAIN_NAME + "mobile/cancelbatch/"
        
        static let ORDER_CANCEL: String
            = DOMAIN_NAME + "mobile/cancelorder/"
        
        static let VERIFY_OTP: String
            = DOMAIN_NAME + "mobile/paymentsuccessful/"
        
        static let SKIP_VERYFICATION: String
            = DOMAIN_NAME + "mobile/skipverification/"
        
        
        static let FINISH_ORDER: String
            = DOMAIN_NAME + "mobile/finishorder/"
        
        static let ADD_ITEM: String
            = DOMAIN_NAME + "mobile/additem"
        
        static let PREVIOUS_ORDER_DETAILS: String
            = DOMAIN_NAME + "mobile/orderdetails/"
        
        static let PREVIOUS_ORDERS: String
            = DOMAIN_NAME + "mobile/previousorders/"
        
        static let TOTAL_ORDER_DETAILS: String
            = DOMAIN_NAME + "order/calculate/details/"
        
        static let PAYMENT_RECEIVED: String
            = DOMAIN_NAME + "mobile/paymentreceived/"
        
        static let ANAL: String
            = DOMAIN_NAME + "mobile/paymentreceived/"
        

        
        static let ANALYTICS_1: String
            = DOMAIN_NAME + "order/filter/analytics/v1/"
        
        static let ANALYTICS_2: String
            = DOMAIN_NAME + "order/filter/analytics/v2/"
        
        static let ANALYTICS_3: String
            = DOMAIN_NAME + "order/filter/analytics/v3/"
 
        
    }
    
    //MARK: - NETWORK CONSTANTS
    
    struct NETWORK {
        static let ALAMOFIRE_TIMEOUT_DURATION: Double = 1 //secs
    }
    
    //MARK: - REQUEST Definitions
    
    struct REQUEST_ID {
        static let CURRENT_ORDER: Int = 1
        
        static let FCM_UPDTAE: Int = 2
        
        static let ACCEPT_ORDER: Int = 3
        
        static let GENERATE_BILL: Int = 4
        
        static let CANCEL_ITEM: Int = 5
        
        static let CANCEL_BATCH: Int = 6
        
        static let ORDER_CANCEL: Int = 7
        
        static let VERIFY_OTP: Int = 8
        
        static let SKIP_VERYFICATION: Int = 9
        
        
        static let FINISH_ORDER: Int = 10
        
        static let ADD_ITEM: Int = 11
        
        static let PREVIOUS_ORDER_DETAILS: Int = 12
        
        static let PREVIOUS_ORDERS: Int = 13
        
        static let TOTAL_ORDER_DETAILS: Int = 14
    
        static let PAYMENT_RECEIVED: Int = 15
        
        static let ANALYTICS_1: Int = 16
        static let ANALYTICS_2: Int = 17
        static let ANALYTICS_3: Int = 18
        static let LOGIN: Int = 19
        
        static let LEARBOARD: Int = 20
  
    }
    
    //MARK: - Razorpay Keys
    
    struct RAZORPAY {
        static let RP_TEST: String = "rzp_test_jXNkkEihmwcFA8"
        static let RP_PRODUCTION: String = "rzp_live_1rlba3fFcVAsLF"
        
    }
    
    //MARK: - Order Status
    
    struct ORDER_STATUS {
        //        coasterscanned
        //        addedtocart
        //        orderplaced
        //        orderaccepted
        //        getbill
        //        paymentcash or paymentcard
        //        paymentcomplete
        
        static let COASTER_SCANNED: String = "coasterscanned"
        static let ADDED_TO_CART: String = "addedtocart"
        static let ORDER_PLACED: String = "orderplaced"
        static let ORDER_ACCEPTED: String = "orderaccepted"
        static let GET_BILL: String = "getbill"
        static let PAYMENT_CASH: String = "paymentcash"
        static let PAYMENT_CARD: String = "paymentcard"
        static let PAYMENT_COMPLETE: String = "paymentcomplete"
        static let ORDER_CANCELLED: String = "ordercancelledbyuser"
    }
}
