//
//  FirstViewController.swift
//  SwiftPedometer
//
//  Created by Thomas Nilsson on 12/06/2018.
//  Copyright © 2018 Thomas Nilsson. All rights reserved.
//

import UIKit
import CoreMotion

class FirstViewController: UIViewController {
    
    var pedometer = CMPedometer()
    
    @IBOutlet weak var label: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Step Count: 0"
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date)
        
        pedometer.startUpdates(from: todayAtMidnight) { (pedometerData, error) in
            if let data = pedometerData {
                
                // Dispatch method to main thread with an async call
                DispatchQueue.main.async {
                    self.label.text = "Step Count: \(data.numberOfSteps)"
                }
               
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

