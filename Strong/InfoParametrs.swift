//
//  InfoParametrs.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import UIKit
import SnapKit

class InfoParametrs: UIView {
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(firstLabel)
        addSubview(secondLabel)
        
        firstLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String, detail: String) {
        firstLabel.text = title
        secondLabel.text = detail
    }
}
