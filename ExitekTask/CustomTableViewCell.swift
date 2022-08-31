//
//  CustomTableViewCell.swift
//  ExitekTask
//
//  Created by Vitaliy Griza on 31.08.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var containerView: UIView!
    var titleLabel: UILabel!
    var yearLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        containerView = UIView().then({ container in
            contentView.addSubview(container)
            container.layer.cornerRadius = 10
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.black.cgColor
            container.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview().inset(30)
                make.height.equalTo(50)
                make.bottom.equalToSuperview().inset(10)
            }
        })
        titleLabel = UILabel().then({ titleLabel in
            containerView.addSubview(titleLabel)
            titleLabel.textColor = .black
            titleLabel.numberOfLines = 0
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.font = .monospacedDigitSystemFont(ofSize: 18, weight: .light)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(10)
            }
        })
        yearLabel = UILabel().then({ yearLabel in
            containerView.addSubview(yearLabel)
            yearLabel.textColor = .black
            yearLabel.numberOfLines = 0
            yearLabel.adjustsFontSizeToFitWidth = true
            yearLabel.font = .monospacedDigitSystemFont(ofSize: 18, weight: .light)
            yearLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.left.equalTo(titleLabel.snp.right).offset(10)
            }
        })
        
    }
    func loadData(film: FilmItem) {
        titleLabel.text = film.title
        yearLabel.text = String(film.year)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
