//
//  ExerciseDetailsUserCase.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import RxSwift

protocol ExerciseDetailsUseCaseProtocol {
    func fetshExerciseInfo(exerciceId: Int) -> Observable<ExerciseInfo>
    func fetshVariation(variationId: Int) -> Observable<Exercise>
}


class ExerciseDetailsUseCase: ExerciseDetailsUseCaseProtocol {
    let exerciseDetailsRepository: ExerciseDetailsRepositoryProtocol

    init(exerciseDetailsRepository: ExerciseDetailsRepositoryProtocol) {
        self.exerciseDetailsRepository = exerciseDetailsRepository
    }
    
    func fetshExerciseInfo(exerciceId: Int) -> Observable<ExerciseInfo> {
        exerciseDetailsRepository.fetshExerciseInfo(exerciseId: exerciceId)
    }
    
    func fetshVariation(variationId: Int) -> Observable<Exercise> {
        exerciseDetailsRepository.fetshVariation(variationId: variationId)
    }
}
