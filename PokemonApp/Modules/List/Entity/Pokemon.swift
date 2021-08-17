//
//  Pokemon.swift
//  PokemonApp
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let num: String
    let img: String
    let type: [PokemonCategoryConstants]
}
