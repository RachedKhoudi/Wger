//
//  ExercisesViewController.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import UIKit
import Swinject
import RxSwift
import RxCocoa
import SwiftUI

class ExerciseDetailsViewController: BaseViewController {
        
    // MARK: Public Properties
    var viewModel: ExerciseDetailsViewModelProtocol
    let container: Container
    
    //MARK: - UI components
    lazy var collectionView: UICollectionView = {
        var collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = UIColor.backgroundColor
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "empty_message".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Init
    init(container: Container) {
        self.container = container
        self.viewModel = container.resolve(ExerciseDetailsViewModelProtocol.self)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureView()
        bind()
        self.state = .loading
        self.viewModel.fetshExerciseInfo()
    }
}

extension ExerciseDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0,
           let images = viewModel.exerciseInfoItemObserver.value?.images {
            return images.count
        } else if section == 1 {
            return viewModel.variationsItemsObserver.value.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.reuseIdentifier, for: indexPath) as! ExerciseCollectionViewCell
        
        if indexPath.section == 0, let images = viewModel.exerciseInfoItemObserver.value?.images {
            cell.setUpView(name: nil, image: images[indexPath.row].image)
        } else if indexPath.section == 1, viewModel.variationsItemsObserver.value.count > 0 {
            let varation = viewModel.variationsItemsObserver.value[indexPath.row]
            cell.setUpView(name: varation.name, image: nil)
        }
        
        return cell
    }
}

extension ExerciseDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            collectionView.deselectItem(at: indexPath, animated: true)
            let item = viewModel.variationsItemsObserver.value[indexPath.row]
            let exerciseDetailsVc = ExerciseDetailsViewController(container: self.container)
            exerciseDetailsVc.viewModel.exerciceId = item.id
            exerciseDetailsVc.viewModel.exerciceName = item.name
            self.navigationController?.pushViewController(exerciseDetailsVc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = indexPath.section == 0 ? "Images" : "Variation Exercies"
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 60
        if section == 0 {
            if viewModel.exerciseInfoItemObserver.value?.images?.count ?? 0 == 0 {
                height = 0
            }
        } else if section == 1 {
            if viewModel.variationsItemsObserver.value.count == 0 {
                height = 0
            }
        }
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = ((collectionView.frame.width - 30) / 2) - flowayout.minimumInteritemSpacing
        let height = ((collectionView.frame.width - 30) / 2) - flowayout.minimumLineSpacing
        return CGSize(width: width, height: height)
    }
}

//MARK: -  View controller private extension

private extension ExerciseDetailsViewController {
    
    func bind() {
        self.viewModel.stateNotifier
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.state = .done
                self.collectionView.reloadData()
                if let images = self.viewModel.exerciseInfoItemObserver.value?.images?.count, images > 0 && self.viewModel.variationsItemsObserver.value.count > 0 {
                    self.collectionView.isHidden = false
                } else {
                    self.collectionView.isHidden = true
                    self.addEmptLabelView()
                }
            }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.errorObserver
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                guard let self = self else {return}
                self.state = .error(error: Network.Errors.serverError, onRetry: {
                    self.viewModel.fetshExerciseInfo()
                })
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func configureView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: ExerciseCollectionViewCell.self)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        collectionView.backgroundColor = UIColor(rgb: 0xF5F5F6)

        collectionView.setCollectionViewLayout(layout, animated: false)
        self.view.addSubview(self.collectionView)
        navigationItem.title = viewModel.exerciceName
    }
    
    func addEmptLabelView() {
        view.addSubview(emptyLabel)
        emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
