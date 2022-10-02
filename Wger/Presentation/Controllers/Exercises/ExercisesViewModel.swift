//
//  ExercisesViewModel.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import RxSwift
import RxCocoa

typealias ExerciseItem = (exercise: Exercise, image: String?)

protocol ExercisesViewModelProtocol {
    var disposeBag: DisposeBag {get}
    var errorObserver: PublishSubject<Error> { get }
    var stateNotifier: PublishSubject<Void> { get }
    var updateImageRowObserver: PublishSubject<Int> { get }

    var exerciseImageObserver : BehaviorRelay<(baseId: Int, imagePath: String)?> {get}
    var exercisesUseCase: ExercisesUseCaseProtocol { get set}
    var exerciseItemsObserver : BehaviorRelay<[ExerciseItem]> {get}

    func fetshExercises()
}

class ExercisesViewModel: BaseViewModel, ExercisesViewModelProtocol {
    var disposeBag: DisposeBag = DisposeBag()
    var errorObserver: PublishSubject<Error> = PublishSubject()
    var stateNotifier: PublishSubject<Void> = PublishSubject()
    var updateImageRowObserver: PublishSubject<Int> = PublishSubject()

    var exerciseImageObserver: BehaviorRelay<(baseId: Int, imagePath: String)?> = BehaviorRelay(value: nil)
    var exercisesUseCase: ExercisesUseCaseProtocol
    var exerciseItemsObserver: BehaviorRelay<[ExerciseItem]> = BehaviorRelay(value: [])

    init(exercisesUseCase: ExercisesUseCaseProtocol) {
        self.exercisesUseCase = exercisesUseCase
    }
    
    func fetshExercises() {
        exercisesUseCase.fetshExercises()
            .subscribe(onNext: {[weak self] exercies in
                guard let self = self else { return }
                self.exerciseItemsObserver.accept(exercies.map({ (exercise: $0, image: nil) }))
                self.stateNotifier.onNext(())
                self.fetchExerciseImage(exerciseBases: exercies.compactMap({ $0.exerciseBase }))
            }, onError: { [weak self] error in
                guard let self = self else {return}
                self.errorObserver.onNext(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchExerciseImage(exerciseBases: [Int]) {
        let opQueue = OperationQueue()
        for baseId in exerciseBases {
            opQueue.addOperation(FetchImageOperation(exercisesUseCase: self.exercisesUseCase, exerciseBase: baseId) { [weak self] string in
                guard let self = self else { return }
                
                var cellRow: Int? = nil
                var exerciseItems = self.exerciseItemsObserver.value
                
                if let row = exerciseItems.firstIndex(where: {$0.exercise.exerciseBase == baseId}) {
                    cellRow = row
                    exerciseItems[row] = (exercise: self.exerciseItemsObserver.value[row].exercise , image: string)
                }
                
                self.exerciseItemsObserver.accept(exerciseItems)
                if let row = cellRow {
                    self.updateImageRowObserver.onNext(row)
                }
            })
        }
    }
    
//    func fetchExerciseImage(exerciseBases: [Int]) {
//        let opQueue = OperationQueue()
//        for baseId in exerciseBases {
//            opQueue.addOperation {
//                self.asyncTask(exerciseBase: baseId) { string in
//                    var cellRow: Int? = nil
//                    var exerciseItems = self.exerciseItemsObserver.value
//
//                    if let row = exerciseItems.firstIndex(where: {$0.exercise.exerciseBase == baseId}) {
//                        cellRow = row
//                        exerciseItems[row] = (exercise: self.exerciseItemsObserver.value[row].exercise , image: string)
//                    }
//
//                    self.exerciseItemsObserver.accept(exerciseItems)
//                    if let row = cellRow {
//                        self.updateImageRowObserver.onNext(row)
//                    }
//                }
//            }
//        }
//    }
    
    func asyncTask(exerciseBase: Int, completion: @escaping (String) -> Void) {
        exercisesUseCase.fetshExercisesMainImages(exerciseBase: exerciseBase)
            .subscribe(onNext: {exercieImage in
                if let image = exercieImage.first?.image {
                  completion(image)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

typealias ImageOperationCompletion = ((String) -> Void)?
final class FetchImageOperation: AsyncOperation {

    private let exerciseBase: Int
    private let exercisesUseCase: ExercisesUseCaseProtocol
    private let disposeBag = DisposeBag()

    private let completion: ImageOperationCompletion

    init(exercisesUseCase: ExercisesUseCaseProtocol, exerciseBase: Int, completion: ImageOperationCompletion = nil) {
        self.exercisesUseCase = exercisesUseCase
        self.exerciseBase = exerciseBase
        self.completion = completion
        super.init()
    }

    override func main() {
        exercisesUseCase.fetshExercisesMainImages(exerciseBase: exerciseBase)
            .subscribe(onNext: {[weak self] exercieImage in
                guard let self = self else { return }
                if let completion = self.completion, let image = exercieImage.first?.image {
                  completion(image)
                }
                self.finish()
            })
            .disposed(by: self.disposeBag)
    }
}
