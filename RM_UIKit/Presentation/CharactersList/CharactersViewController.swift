//
//  CharactersViewController.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit
import Combine
import SnapKit

class CharactersViewController: UIViewController {
    
    // MARK: UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseId)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 220
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        return table
    }()
    
    private let emptyView = EmptyView()
        
    // MARK: Properties
    private var dataSource: UITableViewDiffableDataSource<Int, Character>!
    private var viewModel: CharactersViewModel
    weak var coordinator: RMCoordinatorProtocol?
    
    private var isLandscape: Bool = false
    private var isLoadingMore = false
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDataSource()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = .white
        title = "Rick and Morty Characters"
        view.addSubview(tableView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                guard let self else { return }
                self.updateSnapshot(with: characters)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showActivityIndicator()
                } else {
                    self?.hideActivityIndicator()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap{$0}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.showEmptyView(view: view, message: "List of characters is empty")
                self.showAlert(title: "Error", message: errorMessage)
            }.store(in: &cancellables)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Character>(tableView: tableView) { [weak self] (tableView, indexPath, character) -> UITableViewCell? in
            guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseId, for: indexPath) as? CharacterCell else {
                return UITableViewCell()
            }
            cell.isLandscape = self.isLandscape
            cell.configure(with: character)
            return cell
        }
    }
    
    private func updateSnapshot(with characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Character>()
        snapshot.appendSections([0])
        snapshot.appendItems(characters, toSection: 0)
        
        if characters.isEmpty {
            self.showEmptyView(
                view: view,
                message: "List of characters is empty"
            )
        } else {
            self.hideEmptyView(view: view)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isLandscape = size.width > size.height
        tableView.reloadData()
    }
    
    // MARK: Actions
    @objc private func refreshData(){
        viewModel.loadCharacters()
    }
}

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        coordinator?.showDetail(for: character)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

