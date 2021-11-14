//
//  ExercisesViewController.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import UIKit
import RxSwift
import Swinject
import Kingfisher

class ExercisesViewController: BaseViewController {

    // MARK: Public Properties
    let viewModel: ExercisesViewModelProtocol
    let container: Container
    
    //MARK: - UI components
    lazy var collectionView: UICollectionView = {
        var collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = UIColor(rgb: 0xF5F5F6)
        return view
    }()
    
    //MARK: - Init
    init(container: Container) {
        self.container = container
        self.viewModel = container.resolve(ExercisesViewModelProtocol.self)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tableViewLayout()
        self.configureView()
        self.bind()
        self.bindTableView()
        self.state = .loading
        self.viewModel.fetshExercises()
    }
}

//MARK: - TableView DataSource

extension ExercisesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.exerciseItemsObserver.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.reuseIdentifier, for: indexPath) as! ExerciseCollectionViewCell
        let item = viewModel.exerciseItemsObserver.value[indexPath.row]
        cell.setUpView(name: item.exercise.name, image: item.image)
        return cell
    }
}

//MARK: - CollectionView Delegate

extension ExercisesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = viewModel.exerciseItemsObserver.value[indexPath.row]

        let exerciseDetailsVc = ExerciseDetailsViewController(container: self.container)
        exerciseDetailsVc.viewModel.exerciceId = item.exercise.id
        exerciseDetailsVc.viewModel.exerciceName = item.exercise.name
        self.navigationController?.pushViewController(exerciseDetailsVc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = ((collectionView.frame.width - 30) / 2) - flowayout.minimumInteritemSpacing
        let height = ((collectionView.frame.width - 30) / 2) - flowayout.minimumLineSpacing
        return CGSize(width: width, height: height)
    }
}

//MARK: -  View controller private extension

private extension ExercisesViewController {
    func tableViewLayout() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(self.collectionView.constraints(self.view))
    }
    
    func bind() {
        self.viewModel.stateNotifier
            .subscribe { _ in
                self.state = .done
            }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.errorObserver
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                guard let self = self else {return}
                self.state = .error(error: Network.Errors.serverError, onRetry: {
                    self.viewModel.fetshExercises()
                })
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func bindTableView() {
        viewModel.exerciseItemsObserver
            .distinctUntilChanged{$0.count == $1.count}
            .subscribe(on: MainScheduler.instance)
            .subscribe (onNext: { _ in
                self.collectionView.reloadData()
            })
            .disposed(by: self.viewModel.disposeBag)
        
        viewModel.updateImageRowObserver
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { row in
                let indexPosition = IndexPath(row: row, section: 0)
                self.collectionView.reloadItems(at: [indexPosition])
            })
            .disposed(by: self.viewModel.disposeBag)
    }
    
    func configureView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: ExerciseCollectionViewCell.self)
        navigationItem.title = "Exercises"
    }
}
