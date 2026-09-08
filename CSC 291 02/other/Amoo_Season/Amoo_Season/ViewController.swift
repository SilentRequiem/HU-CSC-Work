//
//  ViewController.swift
//  Amoo_Season
//
//  Created by Michael Amoo on 2/5/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var seasonChange: UILabel!
    
    @IBOutlet var seasonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func winterB(_ sender: Any) {
        view.backgroundColor = .blue
        seasonChange.text = "Winter"
        seasonImage.image = UIImage(named: "Winter") //Chnage image of imageView
        
    }
    
    @IBAction func springB(_ sender: Any) {
        view.backgroundColor = .systemPink
        seasonChange.text = "Spring"
        seasonImage.image = UIImage(named: "Spring")
    }
    
    @IBAction func summerB(_ sender: Any) {
        view.backgroundColor = .green
        seasonChange.text = "Summer"
        seasonImage.image = UIImage(named: "Summer")
    }
    
    @IBAction func fallB(_ sender: Any) {
        
        view.backgroundColor = .systemOrange
        seasonChange.text = "Fall"
        seasonImage.image = UIImage(named: "Fall")
        
    }
    
}
