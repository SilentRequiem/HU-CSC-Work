//
//  ViewController.swift
//  Light
//
//  Created by Michael Amoo on 1/26/25.
//

import UIKit

class ViewController: UIViewController {
    
    var lightOn = true
    //Action = method, Outlet = variable, and Outlet Collection = Array
    override func viewDidLoad() { //Do something before the app loads
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

        func updateUI() { //changes the color
            view.backgroundColor = lightOn ? .white : .black // the (.) is a property
        } // if lightOn, do this if true : do this if false
        
       /* if lightOn {
            view.backgroundColor = .white
            lightButton.setTitle("Off", for: .normal)
        } else {
            view.backgroundColor = .black
            lightButton.setTitle("On", for: .normal)
        } */
    
    @IBAction func buttonPressed(_ sender: Any) {
        lightOn.toggle()
        updateUI()
    }
}


