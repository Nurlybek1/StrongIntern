//
//  MainTableViewCell.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import UIKit
import SnapKit

protocol LearnMoreDelegate {
    func didSelectLearn(index: Int)
}

class MainTableViewCell: UITableViewCell {
    
    var delegate: LearnMoreDelegate?
    var index: Int?
    static let identifier = "MainTableViewCell"
    
    public var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "kz")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    lazy var populationView = LeftRightParametrs()
    lazy var areaView = LeftRightParametrs()
    lazy var currenciesView = LeftRightParametrs()
    
    lazy var countrylabel: UILabel = {
        let label = UILabel()
        label.text = "Kazakhstan"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var capitallabel: UILabel = {
        let label = UILabel()
        label.text = "Astana"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var learnButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 91, height: 22)
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
        
    }()
    
    @objc func buttonTapped() {
        guard let index = index else { return }
        delegate?.didSelectLearn(index: index)
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
        backgroundColor = .white
        contentView.addSubview(image)
        contentView.addSubview(countrylabel)
        contentView.addSubview(capitallabel)
        contentView.addSubview(populationView)
        contentView.addSubview(areaView)
        contentView.addSubview(currenciesView)
        contentView.addSubview(learnButton)
    }
    
    private func setupConstraints(){
        image.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.width.equalTo(50)
        }
        
        countrylabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalTo(image.snp.right).offset(12)
        }
        
        capitallabel.snp.makeConstraints {
            $0.top.equalTo(countrylabel.snp.bottom)
            $0.left.equalTo(image.snp.right).offset(12)
        }
        
        populationView.snp.makeConstraints {
            $0.top.equalTo(capitallabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(12)
        }
        
        areaView.snp.makeConstraints {
            $0.top.equalTo(populationView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(12)
        }
        
        currenciesView.snp.makeConstraints {
            $0.top.equalTo(areaView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(12)
        }
        
        learnButton.snp.makeConstraints {
            $0.top.equalTo(currenciesView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureCell(model: CountryModel) {
        countrylabel.text = model.name?.common
        capitallabel.text = model.capital?.first
        
        if let png = model.flags?.png, let url = URL(string: png) {
            image.load(url: url)
        }
        
        if let population = model.population {
            populationView.setTexts(leftText: "Population: ", rightText: "\(population) mln")
        }
        
        if let area = model.area {
            areaView.setTexts(leftText: "Area:", rightText: "\(area) mln km2")
        }
        
        if let currencies = model.currencies, let symbol = currencies.first?.value.symbol, let name = currencies.first?.value.name {
            currenciesView.setTexts(leftText: "Currencies: ", rightText: "\(symbol) \(name)")
        }
    }
}
