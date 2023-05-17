//
//  LeftRightParametrs.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import UIKit

class LeftRightParametrs: UIView {
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTexts(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
}
