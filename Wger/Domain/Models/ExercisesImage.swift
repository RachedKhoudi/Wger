//
//  ExerciseImage.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import Foundation

// MARK: - ExercisesImage
struct ExercisesImage: Codable {
    let count: Int?
    let results: [ExerciseImage]?
}

// MARK: - ExerciseImage
struct ExerciseImage: Codable {
    let id: Int?
    let uuid: String?
    let exerciseBase: Int?
    let image: String?
    let isMain: Bool?
    let status, style: String?

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case exerciseBase = "exercise_base"
        case image
        case isMain = "is_main"
        case status, style
    }
}
