//
//  ViewController.swift
//  Geo Calculator
//
//  Created by Grant N. Postma on 5/14/19.
//  Copyright © 2019 Grant Postma & Jeff Wagner. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var distanceValue: UILabel!
    
    @IBOutlet weak var lat1: DecimalMinusTextField!
    @IBOutlet weak var lat2: DecimalMinusTextField!

    @IBOutlet weak var long1: DecimalMinusTextField!
    @IBOutlet weak var long2: DecimalMinusTextField!
    
    func deg2rad(_ number: Double) -> Double {
        return (number * .pi / 180)
    }
    
    
    @IBAction func calculate(_ sender: UIButton) {
        guard let lat1 = lat1.text, let lat2 = lat2.text, let long1 = long1.text, let long2 = long2.text else {
            return
        }
        guard let lat1Double = Double(lat1), let lat2Double = Double(lat2), let long1Double = Double(long1), let long2Double = Double(long2) else {
            distanceValue.text = "invaid input"
            return
        }
        
        
        let dlat = deg2rad(lat2Double - lat1Double)
        let dlong = deg2rad(long2Double - long1Double)
        let a = pow(pow(sin(dlat/2),2) + cos(deg2rad(lat1Double)) * cos(deg2rad(lat2Double)) * sin(dlong/2),2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = 6373 * c
        
        distanceValue.text = String(d)
    }
    
    @IBAction func clear(_ sender: Any) {
        lat1.text = ""
        lat2.text = ""
        long1.text = ""
        long2.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lat1.placeholder = "Enter Latitude for p1"
        lat2.placeholder = "Enter Latitude for p2"
        long1.placeholder = "Enter Longitude for p1"
        long2.placeholder = "Enter Latitude for p2"
        lat1.clearButtonMode = .always //.whileEditing
        lat2.clearButtonMode = .always
        long1.clearButtonMode = .always
        long2.clearButtonMode = .always
        
        
    }
    


}

