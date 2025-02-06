//
//  CharacterCell.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit
import SnapKit
import Kingfisher

class CharacterCell: UITableViewCell {
    
    // MARK: UI Elements
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    var isLandscape: Bool = false {
        didSet {
            updateLayout()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.addArrangedSubview(characterImageView)
        stackView.addArrangedSubview(nameLabel)
        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(isLandscape ? 120 : 80)
        }
    }

    private func updateLayout() {
        characterImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(isLandscape ? 120 : 80)
        }
    }

    func configure(with character: Character) {
        nameLabel.text = character.name
        if let url = URL(string: character.image) {
            characterImageView.kf.setImage(with: url)
        } else {
            characterImageView.image = UIImage(systemName: "person.fill")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }
}
