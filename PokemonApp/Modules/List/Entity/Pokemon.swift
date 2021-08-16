//
//  Pokemon.swift
//  PokemonApp
//
//  Created by PremierSoft on 15/08/21.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let num: String
    let image: String
    let types: [String]
}
