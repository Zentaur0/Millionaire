//
//  ResultCell.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import UIKit

// MARK: - ResultCell

final class ResultCell: UITableViewCell {
    
    // MARK: - Static
    
    static let reuseID = "ResultCell"
    
    // MARK: - Properties
    
    private let label = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ResultCell {
    
    func configure(text: String) {
        self.label.text = text
        print(text)
    }
    
    private func setupCell() {
        contentView.addSubview(label)
        contentView.backgroundColor = .white
        label.numberOfLines = 0
        label.textColor = .black
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.bottom.leading.trailing.top.equalToSuperview().inset(20)
        }
    }
    
}
