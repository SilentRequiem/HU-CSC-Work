//
//  ViewController.swift
//  Amoo_CommonInputControls
//
//  Created by Michael Amoo on 2/26/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        print("Button was tapped!")
        
    }
    
    @IBAction func switchToggled(_ sender: Any) {
       

        
        if sender.isOn {
                print("The switch is on!")
            } else {
                print("The switch is off.")
            }
        
        
    }
    
    
    
    
    
    
    
}

