//
//  DetailViewController.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit
import Combine
import Kingfisher
import SnapKit

class DetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        label.textAlignment = .left
        return label
    }()
    
    private let statusLabel = UILabel()
    private let genderLabel = UILabel()
    private let locationLabel = UILabel()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView, stackView].forEach {contentView.addSubview($0)}
        [nameLabel, statusLabel, genderLabel, locationLabel].forEach { stackView.addArrangedSubview($0) }
        
        [statusLabel, genderLabel, locationLabel].forEach { label in
            label.font = .systemFont(ofSize: 18)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.layoutMarginsGuide)
            make.leading.equalTo(contentView.layoutMarginsGuide)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.6)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView.layoutMarginsGuide)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.bottom.equalTo(contentView.layoutMarginsGuide).priority(.low)
        }
    }
    
    private func setupBindings() {
        viewModel.$character
            .compactMap { $0 }
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
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.showEmptyView(view: view, message: Constants.noCharacter)
                self.showAlert(title: Constants.errorTitle, message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func configure(with character: Character) {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        genderLabel.text = "Gender: \(character.gender)"
        locationLabel.text = "Location: \(character.location.name)"
        
        if let url = URL(string: character.image) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "person.fill")
        }
    }
}
