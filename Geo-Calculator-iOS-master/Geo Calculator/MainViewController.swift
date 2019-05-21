//
//  ViewController.swift
//  Geo Calculator
//
//  Created by Grant N. Postma on 5/14/19.
//  Copyright © 2019 Grant Postma & Jeff Wagner. All rights reserved.
//

import UIKit
import Darwin

class MainViewController: UIViewController, settingsViewControllerDelegate {
    func updateUnits(_ distanceUnits: String?) {
        distanceValue.text = distanceUnits;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if let destVC = segue.destination as? settingsViewController {
                destVC.settingsDelegate = self
            }
        
    }
    
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var bearingValue: UILabel!
    @IBOutlet weak var lat1: DecimalMinusTextField!
    @IBOutlet weak var lat2: DecimalMinusTextField!
    @IBOutlet weak var long1: DecimalMinusTextField!
    @IBOutlet weak var long2: DecimalMinusTextField!
    @IBAction func settingspressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToSettings", sender: nil)
    }
    
    func deg2rad(_ number: Double) -> Double {
        return (number * .pi / 180)
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func distplayValues() ->Void {
        guard let lata1 = lat1.text, let lata2 = lat2.text, let long1 = long1.text, let long2 = long2.text else {
            return
        }
        
        guard let lat1Double = Double(lata1), let lat2Double = Double(lata2), let long1Double = Double(long1), let long2Double = Double(long2) else {
            return
        }
        
        let lat1 = deg2rad(lat1Double)
        let lon1 = deg2rad(long1Double)
        let lat2 = deg2rad(lat2Double)
        let lon2 = deg2rad(long2Double)
        let theta = lon1 - lon2;
        var dist = sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(theta)
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (distanceUnits == "Kilometers") {
            dist = dist * 1.609344
        }
        
        if (distanceUnits == "Meters") {
            dist = dist * 1.609344 * 1000
            
        }
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        var bear = rad2deg(rad: radiansBearing)
        
        if(bearingUnits == "Mils") {
            bear = bear * 17.777778
        }
        
        let final_d: Double? = Double(round(100*dist)/100)
        let final_b: Double? = Double(round(100*bear)/100)
        distanceValue.text = String(final_d!) + " " + distanceUnits! + ".";
        bearingValue.text = String(final_b!) + " " + bearingUnits! + ".";
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        view.endEditing(true);
        distplayValues();
    }

    @IBAction func clear(_ sender: Any) {
        view.endEditing(true);
        lat1.text = ""
        lat2.text = ""
        long1.text = ""
        long2.text = ""
        distanceValue.text = "";
        bearingValue.text = "";
    }
    
    @IBAction func saveSettings(segue : UIStoryboardSegue) {
        distplayValues();
    }
    
    var distanceUnits : String? = "Miles";
    var bearingUnits : String? = "Degrees";
    
    func updateUnits(distanceUnits: String?, bearingUnits: String?) {
        self.distanceUnits = distanceUnits
        self.bearingUnits = bearingUnits
        distplayValues();
    }
    
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lat1.placeholder = "enter latitude for p1"
        lat2.placeholder = "enter latitude for p2"
        long1.placeholder = "enter longitude for p1"
        long2.placeholder = "enter longitude for p2"
        
        lat1.clearButtonMode = .always //.whileEditing
        lat2.clearButtonMode = .always
        long1.clearButtonMode = .always
        long2.clearButtonMode = .always
        
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapBackground));
        background.isUserInteractionEnabled = true;
        background.addGestureRecognizer(backgroundTap);
        
    }
    
    @objc
    func tapBackground(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
}





