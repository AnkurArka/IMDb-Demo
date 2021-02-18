//
//  ServiceManagerClass.swift
//  BrainCal
//
//  Created by Logictrix iOS3 on 24/07/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit 
import Alamofire

protocol ProgressChanges
{
    func progress(val: Float)
}

class ServiceManagerClass: NSObject {
    static var delegate: ProgressChanges?
    static var baseUrl =  "https://imdb-api.com/en/API/"
    
    class func  requestWithPost(methodName:String, parameter:[String:Any]?,Auth_header:[String:String], successHandler: @escaping(_ success:JSON) -> Void)
    {
        let parameters: Parameters = parameter!
        var jsonResponse:JSON!
        var errorF:NSError!
        let urlString = baseUrl.appending("\(methodName)")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        let sessionManager =  Alamofire.SessionManager(configuration: configuration)
        
        print("urlString",urlString)
        sessionManager.request(urlString, method: .post, parameters: parameters, encoding:JSONEncoding.default , headers: headers).responseJSON { (response:DataResponse<Any>) in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                errorF = error as NSError
                ServiceManagerClass.alert(message: error.localizedDescription)
                break
            case .success(let value):
                do{
                    let json = try JSON(data: response.data!)
                    _ = [json] as NSArray
                    jsonResponse = json
                    break
                }
                catch{
                    print("error",error.localizedDescription)
                }
            }
            if jsonResponse !=  nil
            {
                successHandler(jsonResponse)
            }
            sessionManager.session.invalidateAndCancel()
        }
    }
    
   
    class func requestWithGet(methodName:String , parameter:[String:Any]?, successHandler: @escaping (_ success:JSON) -> Void) {
        let _:[String:Any] = [:]
            var jsonResponse:JSON!
            let urlString = baseUrl.appending("\(methodName)")
            print(urlString)

            let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
            Alamofire.request(urlString, method: .get, parameters:[:], encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .failure(let error):
                    print(error)
                    ServiceManagerClass.alert(message: error.localizedDescription)
                    break
                case .success(let _):
                    let json = JSON(data: response.data!)
                    print("\(json)")
                    jsonResponse = json
                    successHandler(jsonResponse)
                    break
                }
        }
    }
        
    class func topMostController() -> UIViewController
    {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func alert(message:String)
    {
        let alert=UIAlertController(title: "Alert!", message: message, preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        alert.addAction(cancelAction)
        ServiceManagerClass.topMostController().present(alert, animated: true, completion: nil);
    }
}
