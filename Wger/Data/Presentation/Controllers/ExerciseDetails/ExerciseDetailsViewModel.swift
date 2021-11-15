//
//  ExerciseDetailsViewModel.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import RxSwift
import RxCocoa

protocol ExerciseDetailsViewModelProtocol {
    var disposeBag: DisposeBag {get}
    var exerciceId: Int? {get set}
    var exerciceName: String? {get set}
    var errorObserver: PublishSubject<Error> { get }
    var stateNotifier: PublishSubject<Void> { get }
    var exerciseInfoItemObserver : BehaviorRelay<ExerciseInfo?> {get}
    var variationsItemsObserver : BehaviorRelay<[Exercise]> {get}

    var sectionNumber: Int {get}
    func fetshExerciseInfo()
}

class ExerciseDetailsViewModel: BaseViewModel, ExerciseDetailsViewModelProtocol {
    var disposeBag = DisposeBag()
    var exerciceId: Int?
    var exerciceName: String?
    var errorObserver: PublishSubject<Error> = PublishSubject()
    var stateNotifier: PublishSubject<Void> = PublishSubject()
    var exerciseInfoItemObserver : BehaviorRelay<ExerciseInfo?> = BehaviorRelay(value: nil)
    var variationsItemsObserver : BehaviorRelay<[Exercise]> = BehaviorRelay(value: [])
    var exerciseDetailsUseCase: ExerciseDetailsUseCaseProtocol
    var sectionNumber:Int = 0
    
    init(exerciseDetailsUseCase: ExerciseDetailsUseCaseProtocol) {
        self.exerciseDetailsUseCase = exerciseDetailsUseCase
    }
    
    func fetshExerciseInfo() {
        guard let id = exerciceId else { return }
        exerciseDetailsUseCase.fetshExerciseInfo(exerciceId: id)
            .subscribe(onNext: {[weak self] exercieInfo in
                guard let self = self else { return }
                self.exerciseInfoItemObserver.accept(exercieInfo)
                self.updateSectionNumber(exercieInfo: exercieInfo)
                self.fetchVariationsExercises(variations: exercieInfo.variations)
            }, onError: { [weak self] error in
                guard let self = self else {return}
                self.errorObserver.onNext(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateSectionNumber(exercieInfo: ExerciseInfo) {
        self.sectionNumber = 0
        if let imageCount = exercieInfo.images?.count,
           imageCount > 0 {
            self.sectionNumber += 1
        }
        if let ariationCount = exercieInfo.variations?.count,
           ariationCount > 0 {
            self.sectionNumber += 1
        }
    }
    
    func fetchVariationsExercises(variations: [Int]?) {
        guard let ids = variations, ids.count > 0 else {
            self.stateNotifier.onNext(())
            return }
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        var variations: [Exercise] = []
        for id in ids {
            opQueue.addOperation(FetchVariationOperation(exerciDetailsesUseCase: self.exerciseDetailsUseCase, variationId: id){ variation in
                variations.append(variation)
                if variations.count == ids.count {
                    self.variationsItemsObserver.accept(variations)
                    self.stateNotifier.onNext(())
                }
            })
        }
    }
}

typealias VariationOperationCompletion = ((Exercise) -> Void)?
final class FetchVariationOperation: AsyncOperation {

    private let variationId: Int
    private let exerciseDetailsUseCase: ExerciseDetailsUseCaseProtocol
    private let disposeBag = DisposeBag()

    private let completion: VariationOperationCompletion

    init(exerciDetailsesUseCase: ExerciseDetailsUseCaseProtocol, variationId: Int, completion: VariationOperationCompletion = nil) {
        self.exerciseDetailsUseCase = exerciDetailsesUseCase
        self.variationId = variationId
        self.completion = completion
        super.init()
    }

    override func main() {
        exerciseDetailsUseCase.fetshVariation(variationId: variationId)
            .subscribe(onNext: {[weak self] variation in
                guard let self = self else { return }
                if let completion = self.completion {
                  completion(variation)
                }
                self.finish()
            })
            .disposed(by: self.disposeBag)
    }
}
