//
//  Terrain.swift
//  Amoo_TrailAnalyzer
//
//  Created by Computer Science Swift on 9/7/26.
//


import Foundation


enum Terrain: String, Identifiable, CaseIterable {
    case paved
    case dirt
    case rocky
    case sandy


    var id: String {
        rawValue
    }
}