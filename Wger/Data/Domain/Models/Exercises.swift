//
//  Exercies.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation

// MARK: - Exercises
struct Exercises: Codable {
    let count: Int?
    let next: String?
    let results: [Exercise]?
}

// MARK: - Exercise
struct Exercise: Codable {
    let id: Int?
    let uuid, name: String?
    let exerciseBase: Int?
    let status, resultDescription, creationDate: String?
    let category: Int?
    let muscles, musclesSecondary, equipment: [Int]?
    let language, license: Int?
    let licenseAuthor: String?
    let variations: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case status
        case resultDescription = "description"
        case creationDate = "creation_date"
        case category, muscles
        case musclesSecondary = "muscles_secondary"
        case equipment, language, license
        case licenseAuthor = "license_author"
        case variations
    }
}
