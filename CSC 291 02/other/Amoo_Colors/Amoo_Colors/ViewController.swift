//
//  ViewController.swift
//  Amoo_Colors
//
//  Created by Michael Amoo on 1/31/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var currentColor: UILabel!
    
    @IBAction func redPressed(_ sender: Any) {
        view.backgroundColor = .red //changeBackground
        currentColor.text = "Red Color"
    } //Control-Click drag to make it an action.
    //In this case it allows the button to be pressed.
    
    @IBAction func orangePressed(_ sender: Any) {
        view.backgroundColor = .orange
        currentColor.text = "Orange Color"
    }
    
    @IBAction func yellowPressed(_ sender: Any) {
        view.backgroundColor = .yellow
        currentColor.text = "Yellow Color"
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        view.backgroundColor = .green
        currentColor.text = "Green Color"
    }
    
    
}

