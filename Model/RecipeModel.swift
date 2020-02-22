//
//  RecipeModel.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import Foundation


struct RecipeModel: Codable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {

        let uri: String
       let label: String
       let image: String
       let source: String
       let url: String
       let shareAs: String
       let yield: Double
       let dietLabels: [String]
       let healthLabels: [String]
       let ingredientLines: [String]
}
