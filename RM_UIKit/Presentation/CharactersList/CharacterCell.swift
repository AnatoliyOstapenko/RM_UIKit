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
    static let reuseIdentifier = "CharacterCell"

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

    var isLandscape: Bool = false {
        didSet {
            updateImageViewConstraints()
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
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
    }

    private func setupConstraints() {
        updateImageViewConstraints()
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(characterImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func updateImageViewConstraints() {
        characterImageView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            let size: CGFloat = isLandscape ? 120 : 80
            make.width.height.equalTo(size)
        }
    }

    func configure(with character: Character) {
        nameLabel.text = character.name
        if let url = URL(string: character.image) {
            characterImageView.kf.setImage(with: url)
        } else {
            characterImageView.image = UIImage(systemName: "person.fill") // Placeholder image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }
}

