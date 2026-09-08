//
//  ViewController.swift
//  Amoo_CSC291Exam1
//
//  Created by Michael Amoo on 2/10/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorImage: UIImageView!
    
    @IBOutlet var colorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func redPressed(_ sender: Any) {
        view.backgroundColor = .red
        colorLabel.text = "RED background"
        colorImage.image = UIImage(named: "redB")
    }
    
    @IBAction func orangePressed(_ sender: Any) {
        view.backgroundColor = .orange
        colorLabel.text = "ORANGE background"
        colorImage.image = UIImage(named: "orangeF")
    }
    
    @IBAction func bluePressed(_ sender: Any) {
        view.backgroundColor = .blue
        colorLabel.text = "BLUE background"
        colorImage.image = UIImage(named: "blueB")
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        view.backgroundColor = .green
        colorLabel.text = "GREEN background"
        colorImage.image = UIImage(named: "greenT")
    }
    

}

