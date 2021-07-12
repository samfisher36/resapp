//
//  NetworkInteractionDelegate.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 25/01/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkInteractionDelegate {
    func onSuccess(requestId: Int, response: AFDataResponse<Any>)
    func onFailure()
    func notAuthorized()
    func noInternetConnectivity()
}
