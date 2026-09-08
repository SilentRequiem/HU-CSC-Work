//
//  ViewController.swift
//  Amoo_Ex1Review
//
//  Created by Michael Amoo on 2/7/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var favoriteImage: UIImageView!
    
    @IBOutlet var myFavoriteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func moviePressed(_ sender: Any) {
        myFavoriteLabel.text = "Harlem Heights"
        favoriteImage.image = UIImage(named: "MovieP")
        view.backgroundColor = .brown
        
    }
    
    @IBAction func sportPressed(_ sender: Any) {
        myFavoriteLabel.text = "Lakers"
        favoriteImage.image = UIImage(named: "SportsP")
        view.backgroundColor = .purple
    }
    
    
    @IBAction func restaurantPressed(_ sender: Any) {
        myFavoriteLabel.text = "Rasing Canes"
        favoriteImage.image = UIImage(named: "RestaurantP")
        view.backgroundColor = .brown
    }
    
    @IBAction func treePressed(_ sender: Any) {
        myFavoriteLabel.text = "Oak"
        favoriteImage.image = UIImage(named: "OakP")
        view.backgroundColor = .blue
    }
}

