//
//  ExercisesInfo.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import Foundation

// MARK: - CollectionResponse
struct ExerciseInfo: Codable {
    let id: Int?
    let name, uuid, collectionResponseDescription, creationDate: String?
    let category: Category?
    let muscles, musclesSecondary: [Muscle]?
    let equipment: [Category]?
    let language, license: Language?
    let licenseAuthor: String?
    let images: [ExerciseImage]?
    let variations: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name, uuid
        case collectionResponseDescription = "description"
        case creationDate = "creation_date"
        case category, muscles
        case musclesSecondary = "muscles_secondary"
        case equipment, language, license
        case licenseAuthor = "license_author"
        case images, variations
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Language
struct Language: Codable {
    let id: Int?
    let shortName, fullName: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
        case url
    }
}

// MARK: - Muscle
struct Muscle: Codable {
    let id: Int?
    let name: String?
    let isFront: Bool?
    let imageURLMain, imageURLSecondary: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isFront = "is_front"
        case imageURLMain = "image_url_main"
        case imageURLSecondary = "image_url_secondary"
    }
}
