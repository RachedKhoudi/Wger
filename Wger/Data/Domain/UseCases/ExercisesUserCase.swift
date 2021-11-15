//
//  ExerciesUserCase.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import RxSwift

protocol ExercisesUseCaseProtocol {
    func fetshExercises() -> Observable<[Exercise]>
    func fetshExercisesMainImages(exerciseBase: Int) -> Observable<[ExerciseImage]>
}

class ExercisesUseCase: ExercisesUseCaseProtocol {
    let exercisesRepository: ExercisesRepositoryProtocol
    
    init(exercisesRepository: ExercisesRepositoryProtocol) {
        self.exercisesRepository = exercisesRepository
    }
    
    func fetshExercises() -> Observable<[Exercise]> {
        return self.exercisesRepository.fetshExercises()
    }
    
    func fetshExercisesMainImages(exerciseBase: Int) -> Observable<[ExerciseImage]> {
        return self.exercisesRepository.fetshExercisesMainImages(exerciseBase: exerciseBase)
    }
}
