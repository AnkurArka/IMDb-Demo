//
//  APIController.swift
//  BrainCal
//
//  Created by Logictrix iOS3 on 24/07/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class APIController: NSObject
{
    
    /*
     Method Name:- getMovieList
     Description:- To get movies list through IMDB API call
     Date:- 18-02-2021
     Created By:- Ankur Sharma
     Modified By:-
     Modified Date:-
     */
    
    static func getMovieList(SuccessHandler: @escaping (_ responce:JSON) -> Void)
    {
        guard Reachability.isConnectedToNetwork() else{
            ServiceManagerClass.alert(message: "Please check your internet connection")
            return
        }

        ServiceManagerClass.requestWithGet(methodName: "Top250Movies/k_fmpsg163", parameter: [:]) { (jsonResponse) in
            if(jsonResponse["errorMessage"] == "")
            {
                SuccessHandler(jsonResponse)
            }
            else
            {
                ServiceManagerClass.alert(message: jsonResponse["errorMessage"].stringValue)
                
            }
        }
    }
    
    
    /*
     Method Name:- getMovieDetail
     Description:- To get movies details through IMDB API call
     Date:- 18-02-2021
     Created By:- Ankur Sharma
     Modified By:-
     Modified Date:-
     */
    static func getMovieDetail(id: String, SuccessHandler: @escaping (_ responce:JSON) -> Void)
    {
        guard Reachability.isConnectedToNetwork() else{
            ServiceManagerClass.alert(message: "Please check your internet connection")
            return
        }

        ServiceManagerClass.requestWithGet(methodName: "Title/k_fmpsg163/\(id)", parameter: [:]) { (jsonResponse) in
            if(jsonResponse["errorMessage"] == "")
            {
                SuccessHandler(jsonResponse)
            }
            else
            {
                ServiceManagerClass.alert(message: jsonResponse["errorMessage"].stringValue)
                
            }
        }
    }
}
