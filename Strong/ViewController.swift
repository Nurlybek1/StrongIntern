//
//  ViewController.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    var countries: [CountryModel] = []
    var expandedRows: Set<Int> = []
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "World Countries"
        
        getCountries()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.right.left.bottom.equalToSuperview()
        }
    }
}

extension ViewController {
    func getCountries() {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
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
                self.countries = responseModel
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        cell.configureCell(model: countries[indexPath.row])
        
        let hide = !(expandedRows.contains(indexPath.row))
        cell.learnButton.isHidden = hide
        cell.populationView.isHidden = hide
        cell.areaView.isHidden = hide
        cell.currenciesView.isHidden = hide
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        if expandedRows.contains(indexPath.row) {
            expandedRows.remove(indexPath.row)
        } else {
            expandedRows.insert(indexPath.row)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedRows.contains(indexPath.row) {
            return 200
        } else {
            return 72
        }
    }
}

extension ViewController: LearnMoreDelegate {
    func didSelectLearn(index: Int) {
        guard let code = countries[index].cca2 else { return }
        let vc = InfoViewController(code: code)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
