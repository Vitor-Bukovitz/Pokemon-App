//
//  PokemonCategoryConstants.swift
//  PokemonApp
//

import UIKit

enum PokemonCategoryConstants: String, Codable {
    case normal = "Normal"
    case fire = "Fire"
    case water = "Water"
    case grass = "Grass"
    case eletrict = "Electric"
    case ice = "Ice"
    case fighting = "Fighting"
    case poison = "Poison"
    case ground = "Ground"
    case flying = "Flying"
    case psychic = "Psychic"
    case bug = "Bug"
    case rock = "Rock"
    case ghost = "Ghost"
    case dark = "Dark"
    case dragon = "Dragon"
    case steel = "Steel"
    case fairy = "Fairy"
    
    func getColor() -> UIColor {
        switch self {
        case .normal:
            return UIColor(0xC3C0B6)
        case .fire:
            return UIColor(0xFB6C6C)
        case .water:
            return UIColor(0x76BDFE)
        case .grass:
            return UIColor(0x48D0B0)
        case .eletrict:
            return UIColor(0xFFD86F)
        case .ice:
            return UIColor(0x75D5F4)
        case .fighting:
            return UIColor(0x77341D)
        case .poison:
            return UIColor(0x883E88)
        case .ground:
            return UIColor(0xD0AF56)
        case .flying:
            return UIColor(0x5E75D3)
        case .psychic:
            return UIColor(0xEB437E)
        case .bug:
            return UIColor(0xA6B61C)
        case .rock:
            return UIColor(0x9F873D)
        case .ghost:
            return UIColor(0x5C5DAF)
        case .dark:
            return UIColor(0x4F3929)
        case .dragon:
            return UIColor(0x745CDD)
        case .steel:
            return UIColor(0x908F9F)
        case .fairy:
            return UIColor(0xEFAEF2)
        }
    }
}
