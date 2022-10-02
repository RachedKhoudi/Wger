//
//  WgerTests.swift
//  WgerTests
//
//  Created by Rached Khoudi on 13/11/2021.
//

import XCTest
import Swinject
import RxSwift
import RxCocoa
import Alamofire
@testable import Wger

class WgerTests: XCTestCase {
    
    var session: Session!
    var container: Container!
    var assembly: AppAssembly!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        session = Alamofire.Session(configuration: configuration)
        container = Container()
        assembly = AppAssembly()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        session = nil
        container = nil
        assembly = nil
        disposeBag = nil
    }
    
    func testValidExercisesApiCall() throws {
        
        let promise = expectation(description: "Status code: 200")

        do {
            // given
            let url = try API.Wger.exercises.asURLRequest()
            
            //TODO 1: prevents network request
            // when
            session.request(url)
                .validate()
                .responseJSON(completionHandler: { response in
                    // then
                    guard response.error == nil else {
                        if let error = response.error {
                            XCTFail("Error: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    guard response.response?.statusCode != nil else {
                        if let error = response.error {
                            XCTFail("Error: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    switch response.result {
                    case .success:
                        do {
                            promise.fulfill()
                        }
                    case .failure:
                        if let statusCode = response.response?.statusCode {
                            XCTFail("Error: \(statusCode)")
                        }
                        break
                    }
                })
        } catch(let error) {
            XCTFail("Error: \(error.localizedDescription)")
        }

        
        wait(for: [promise], timeout: 5)
    }
    
    func testDisplayEmptyView() {
        // given
        assembly.assemble(container: container)
        let exerciseDetailsVc = ExerciseDetailsViewController(container: self.container)

        //Fix 1: add loadViewIfNeeded after every creation of viewcontrollers
        exerciseDetailsVc.loadViewIfNeeded()
        
        // when
        exerciseDetailsVc.viewModel.exerciseInfoItemObserver.accept(nil)
        exerciseDetailsVc.viewModel.variationsItemsObserver.accept([])
        exerciseDetailsVc.viewModel.stateNotifier.onNext(())

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(exerciseDetailsVc.collectionView.isHidden, true)
//        }
    }
}
