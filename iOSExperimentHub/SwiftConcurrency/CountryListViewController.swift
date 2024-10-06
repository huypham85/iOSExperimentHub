//
//  CountryListViewController.swift
//  iOSExperimentHub
//
//  Created by Huy Pham on 28/9/24.
//

import UIKit

class CountryListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    private var countries: [Country] = []
    let countryFetcher = CountryFetcher()
    
    private var activeContinuation: CheckedContinuation<[Country], Error>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        Task {
            do {
                self.countries = try await fetchCountries()
                self.tableView.reloadData()
            } catch(let error) {
                print("fetch countries error: \(error)")
            }
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        countryFetcher.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Countries"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
    }
    
    func fetchCountries() async throws -> [Country] {
        try await withCheckedThrowingContinuation { continuation in
            self.activeContinuation = continuation
            self.countryFetcher.fetchCountries()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as? CountryListTableViewCell else {
            return UITableViewCell()
        }
        Task {
            await cell.setData(countries[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped the country \(countries[indexPath.row].name)")
    }
}

extension CountryListViewController: CountryFetcherDelegate {
    func onLoadSuccessfully(countries: [Country]) {
        self.activeContinuation?.resume(returning: countries)
        self.activeContinuation = nil
    }
    
    func onLoadError(error: CountryFetcherError) {
        self.activeContinuation?.resume(throwing: error)
        self.activeContinuation = nil
    }
    
    
    
}
