//
//  ExerciesRepository.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import RxSwift

protocol ExercisesRepositoryProtocol {
    func fetshExercises() -> Observable<[Exercise]>
    func fetshExercisesMainImages(exerciseBase: Int) -> Observable<[ExerciseImage]>
}

class ExercisesRepository: ExercisesRepositoryProtocol {
    
    let networkManager: NetworkingManagerProtocol
    
    init(networkManager: NetworkingManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetshExercises() -> Observable<[Exercise]> {
        return networkManager.request(source: .exercises, ofType: Exercises.self).compactMap({ $0.results }).asObservable()
    }
    
    func fetshExercisesMainImages(exerciseBase: Int) -> Observable<[ExerciseImage]> {
        return networkManager.request(source: .exerciseImage(isMain: true, exerciseBase: exerciseBase), ofType: ExercisesImage.self).compactMap({ $0.results }).asObservable()
    }
}
