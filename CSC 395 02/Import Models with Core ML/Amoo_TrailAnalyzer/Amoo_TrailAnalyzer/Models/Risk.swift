//
//  Risk.swift
//  Amoo_TrailAnalyzer
//
//  Created by Computer Science Swift on 9/7/26.
//


import Foundation


enum Risk: String, Identifiable, CaseIterable {
    case highRisk = "High Risk"
    case difficult = "Difficult"
    case moderate = "Moderate"
    case easy = "Easy"


    var id: String {
        rawValue
    }


    var image: String {
        rawValue
    }


    var description: String {
        switch self {
        case .easy:
            return "Bring the essentials (water, bug spray, sunscreen) and get ready to enjoy a nice stroll. Be sure to log your hike in your fitness app to keep track of your progress. Have your camera ready to capture the great views and good times!"
        case .moderate:
            return "As with any hike, make sure you bring plenty of water, sunscreen, bug spray, and snacks. Plan for some breaks along the way to keep your energy up, and check your health and fitness apps to monitor your heart rate and energy levels. You got this!"
        case .difficult:
            return "This hike is challenging! Make sure you prepare with the right gear and supplies and turn on location sharing with a trusted friend. "
        case .highRisk:
            return "This hike may push you beyond your limits. Maybe try a more moderate hike and work your way up to this."
        }
    }
}
