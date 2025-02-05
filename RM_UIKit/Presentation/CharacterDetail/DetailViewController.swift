//
//  DetailViewController.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit
import Combine
import Kingfisher

class DetailViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private var viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: DetailViewModel, characterName: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = characterName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [imageView, nameLabel, statusLabel, genderLabel, locationLabel].forEach{view.addSubview($0)}
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func setupBindings() {
        viewModel.$character
            .compactMap{$0}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] character in
                guard let self else { return }
                self.configure(with: character)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showActivityIndicator()
                } else {
                    self?.hideActivityIndicator()
                }
            }.store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap{$0}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.showEmptyView(view: view, message: "Character not found")
                self.showAlert(title: "Error", message: errorMessage)
            }.store(in: &cancellables)
    }

    private func configure(with character: Character) {
        nameLabel.text = character.name
        statusLabel.text = character.status
        genderLabel.text = character.gender
        locationLabel.text = character.location.name

        if let url = URL(string: character.image) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "person.fill")
        }
    }
}
