//
//  InfoViewController.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import UIKit
import SnapKit


class InfoViewController: UIViewController {
    
    private let code: String
    
    public var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "kz")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    lazy var regionView = InfoParametrs()
    lazy var capitalView = InfoParametrs()
    lazy var coordinateView = InfoParametrs()
    lazy var populationView = InfoParametrs()
    lazy var areaView = InfoParametrs()
    lazy var currencyView = InfoParametrs()
    lazy var timezoneView = InfoParametrs()
    
    init(code: String) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getCountryData()
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        [image, regionView, capitalView, coordinateView, populationView, areaView, currencyView, timezoneView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        image.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.equalToSuperview().inset(12)
            $0.height.equalTo(275)
            
        }
        
        regionView.snp.makeConstraints(){
            $0.top.equalTo(image.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        capitalView.snp.makeConstraints(){
            $0.top.equalTo(regionView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        coordinateView.snp.makeConstraints(){
            $0.top.equalTo(capitalView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        populationView.snp.makeConstraints(){
            $0.top.equalTo(coordinateView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        areaView.snp.makeConstraints(){
            $0.top.equalTo(populationView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        currencyView.snp.makeConstraints(){
            $0.top.equalTo(areaView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
        
        timezoneView.snp.makeConstraints(){
            $0.top.equalTo(currencyView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(12)
        }
    }

    func configureViews(model: CountryModel) {
        if let png = model.flags?.png, let url = URL(string: png) {
            image.load(url: url)
        }
        
        if let region = model.region {
            regionView.configureView(title: "Region:", detail: region)
        }
        
        if let capital = model.capital?.first {
            capitalView.configureView(title: "Capital", detail: capital)
        }
        
        if let latlng = model.capitalInfo?.latlng, let lat = latlng.first, let lng = latlng.last {
            coordinateView.configureView(title: "Capital coordinates:", detail: "\(lat), \(lng)")
        }
        
        if let population = model.population {
            populationView.configureView(title: "Population:", detail: "\(population) mln")
        }
        
        if let area = model.area {
            areaView.configureView(title: "Area:", detail: "\(area) mln km2")
        }
        
        if let currencies = model.currencies, let symbol = currencies.first?.value.symbol, let name = currencies.first?.value.name {
            currencyView.configureView(title: "Currency:", detail: "\(symbol) \(name)")
        }
        
        if let timezone = model.timezones?.first {
            timezoneView.configureView(title: "Timezones:", detail: timezone)
        }
    }
}

extension InfoViewController {
    func getCountryData() {
        guard let url = URL(string: "https://restcountries.com/v3.1/alpha/\(code)") else {
            fatalError("Invalid URL")
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let responseModel = try JSONDecoder().decode([CountryModel].self, from: data)
                guard let model = responseModel.first else { return }
                DispatchQueue.main.async {
                    self.configureViews(model: model)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}
