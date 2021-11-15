//
//  ExercieDetailsRepository.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import RxSwift

protocol ExerciseDetailsRepositoryProtocol {
    func fetshExerciseInfo(exerciseId: Int) -> Observable<ExerciseInfo>
    func fetshVariation(variationId: Int) -> Observable<Exercise>
}

class ExerciseDetailsRepository: ExerciseDetailsRepositoryProtocol {
    
    let networkManager: NetworkingManagerProtocol

    init(networkManager: NetworkingManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetshExerciseInfo(exerciseId: Int) -> Observable<ExerciseInfo> {
        networkManager.request(source: API.Wger.exerciseInfo(exerciseId: exerciseId), ofType: ExerciseInfo.self).asObservable()
    }
    
    func fetshVariation(variationId: Int) -> Observable<Exercise> {
        networkManager.request(source: API.Wger.variation(variationId: variationId), ofType: Exercise.self).asObservable()
    }
}
