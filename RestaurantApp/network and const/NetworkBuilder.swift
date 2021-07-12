//
//  NetworkBuilder.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 25/01/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import Foundation
import Alamofire

class NetworkBuilder {
    
    let alamofireManager = Alamofire.Session.default
    
    private func getAlamofireManager() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION  //secs
        
        let alamofireObj = Alamofire.Session(configuration: configuration)
        
        return alamofireObj
    }
    
    func makePostRequest(delegate: NetworkInteractionDelegate, headers: HTTPHeaders, postURL: String,parameters: Parameters, requestID: Int) {
        
        print("--------------------")
        print("POST URL: " + postURL)
        print("Parameters: \(parameters)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            
            alamofireManager.request(postURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Success: \(response)")
                    self.parseSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    break
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                    break
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
        
    }
    
    func makeGetRequest(delegate: NetworkInteractionDelegate, getURL: String, parameters: Parameters, headers:HTTPHeaders, requestID: Int){
        
        print("--------------------")
        print("GET URL: " + getURL)
        print("Parameters: \(parameters)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            alamofireManager.request(getURL, method:.get, parameters: parameters, headers:headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Success: \(response)")
                    //self.parseSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    delegate.onSuccess(requestId: requestID, response: response)
                    break
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
    }

/*
    func makeMultiPartPostRequest(
        delegate: NetworkInteractionDelegate,
        multiPartURL: String,
        jsonString: String,
        headers:HTTPHeaders,
        requestID: Int,
        documentList: [String: URL]?
        )
    {
        
        print("--------------------")
        print("MultiPart POST URL: " + multiPartURL)
        print("JSON Body: \(jsonString)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            alamofireManager.upload(
                multipartFormData: {
                    (multipartFormData) in
                    multipartFormData.append(jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "data_json")
                    if documentList != nil {
                        for (key, value) in documentList! {
                            multipartFormData.append( value, withName: key)
                        }
                    }
                    print("Multipart Form Data: \(multipartFormData)")
            }, to:multiPartURL, method:.post, headers: headers){
                (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        self.printProgress(progress: progress)
                    })
                    
                    upload.responseString { response in
                        print("Success: \(response)")
                        self.parseMultipartSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    }
                    
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                    
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
    }
 
    
    func makeMultiPartPutRequest(
        delegate: NetworkInteractionDelegate,
        multiPartURL: String,
        jsonString: String,
        headers:HTTPHeaders,
        requestID: Int,
        documentList: [String: URL]?
        ){
        print("--------------------")
        print("MultiPart PUT URL: " + multiPartURL)
        print("JSON Body: \(jsonString)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            alamofireManager.upload(
                multipartFormData: {
                    (multipartFormData) in
                    multipartFormData.append(jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "data_json")
                    if documentList != nil {
                        for (key, value) in documentList! {
                            multipartFormData.append( value, withName: key as String)
                        }
                    }
                    print("Multipart Form Data: \(multipartFormData)")
            }, to:multiPartURL, method:.put, headers: headers){
                (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        self.printProgress(progress: progress)
                    })
                    
                    upload.responseString { response in
                        print("Success: \(response)")
                        self.parseMultipartSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    }
                    
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                    
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
    }
 */
    func printProgress(progress: Progress) {
        
        print("--------------------")
        print("fractionCompleted: \(Double(progress.fractionCompleted * 100))%")
        print("completedUnit: \(Double(progress.completedUnitCount) / 1024) KB")
        print("totalUnitCount: \(Double(progress.totalUnitCount) / 1024) KB")
        print("--------------------")
    }
    
    func makeDeleteRequest(delegate: NetworkInteractionDelegate, deleteURL: String, parameters: Parameters, headers:HTTPHeaders, requestID: Int){
        
        print("--------------------")
        print("DELETE URL: " + deleteURL)
        print("Parameters: \(parameters)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            alamofireManager.request(deleteURL, method:.delete, parameters: parameters, headers:headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Success: \(response)")
                    self.parseSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    break
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
    }
    
    func makePutRequest(delegate: NetworkInteractionDelegate,putURL: String, parameters: Parameters, headers:HTTPHeaders, requestID: Int){
        
        print("--------------------")
        print("PUT URL: " + putURL)
        print("Parameters: \(parameters)")
        print("--------------------")
        
        if NetworkReachabilityManager()!.isReachable {
            alamofireManager.session.configuration.timeoutIntervalForRequest = Constant.NETWORK.ALAMOFIRE_TIMEOUT_DURATION
            alamofireManager.request(putURL, method:.put, parameters: parameters,encoding: JSONEncoding.default, headers:headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Success: \(response)")
                    self.parseSuccessJSON(response: response, delegate: delegate, requestId: requestID)
                    break
                case .failure(let error):
                    self.parseFailureJSON(error: error, delegate: delegate)
                }
            }
        } else {
            delegate.noInternetConnectivity()
        }
    }
    
    func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func parseSuccessJSON(response: AFDataResponse<Any>, delegate: NetworkInteractionDelegate, requestId: Int) {
        do {//Not required for me!!
            if let JSON = try response.result.get() as? NSDictionary {
                let message = JSON.object(forKey: "message") as? String
                
                if message != nil && message == "Not Authorized" {
                    delegate.notAuthorized()
                } else {
                    delegate.onSuccess(requestId: requestId, response: response)
                }
            }
             else if let JSON = try response.result.get() as? NSArray {
                    delegate.onSuccess(requestId: requestId, response: response)
                }
            
            else {
                print("Delegate")
                delegate.onFailure()
            }
        } catch let error as NSError {
            print(error)
            delegate.onFailure()
        }
    }
    
    func parseMultipartSuccessJSON(response: DataResponse<String, Error>, delegate: NetworkInteractionDelegate, requestId: Int) {
        do {
            if let data = try response.result.get().data(using: String.Encoding.utf8) {
                if let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    let message = JSON.object(forKey: "message") as? String
                    if message != nil && message == "Not Authorized" {
                        delegate.notAuthorized()
                    } else {
                     //   (delegate as? MultiPartNetworkInteractionDelegate)?.onSuccess(requestId: requestId, response: response)
                    }
                } else {
                    delegate.onFailure()
                }
            } else {
                delegate.onFailure()
            }
        } catch let error as NSError {
            print(error)
            delegate.onFailure()
        }
    }
    
    func parseFailureJSON(error: Error, delegate: NetworkInteractionDelegate) {
        print("Failure: \(error)")
        if error._code == NSURLErrorTimedOut {
            delegate.noInternetConnectivity()
        }
        else {
            delegate.onFailure()
        }
    }
    
//    func updateParameterFields(parameters:Parameters) -> Parameters {
//        var parameters = parameters
//        parameters.updateValue("Employee", forKey: "portal_type")
//        parameters.updateValue("mobile", forKey: "access_from")
//
//        return parameters
//    }
}

