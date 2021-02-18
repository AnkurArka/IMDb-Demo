//
//  ReachibilityToInternet.swift
//  BrainCal
//
//  Created by Logictrix iOS3 on 24/07/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import Alamofire

class ReachibilityToInternet: NSObject {
    static let sharedInstance = ReachibilityToInternet()
    var netStatus:String = ""
    private override init() {
        super.init()
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                self.netStatus = "Unreachable"
            case .unknown :
                print("It is unknown whether the network is reachable")
                self.netStatus = "Unknown"
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                self.netStatus = "WiFi"
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                self.netStatus = "WWAN"
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
