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
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
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

extension ExercisesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exerciseItemsObserver.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.reuseIdentifier) as! ExerciseTableViewCell
        let item = viewModel.exerciseItemsObserver.value[indexPath.row]
        cell.nameLabel.text = item.exercise.name
        cell.mainImageView.kf.setImage(with: URL(string: item.image ?? ""), placeholder: UIImage(named: "placeholder"))
        return cell
    }
}

//MARK: - TableView Delegate

extension ExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}

//MARK: -  View controller private extension

private extension ExercisesViewController {
    func tableViewLayout() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(self.tableView.constraints(self.view))
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
            .subscribe (onNext: { v in
                self.tableView.reloadData()
            })
            .disposed(by: self.viewModel.disposeBag)
        
        viewModel.updateImageRowObserver
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { row in
                let indexPosition = IndexPath(row: row, section: 0)
                self.tableView.reloadRows(at: [indexPosition], with: .none)
            })
            .disposed(by: self.viewModel.disposeBag)
    }
    
    func configureView() {
        tableView.register(cellType: ExerciseTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Exercises"
    }
}
