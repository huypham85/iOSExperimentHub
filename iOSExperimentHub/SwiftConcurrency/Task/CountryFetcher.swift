//
//  CountryFetcher.swift
//  iOSExperimentHub
//
//  Created by Huy Pham on 5/10/24.
//

import Foundation

protocol CountryFetcherDelegate {
    func onLoadSuccessfully(countries: [Country])
    func onLoadError(error: CountryFetcherError)
}

struct CountryFetcherError: Error {}

class CountryFetcher {
    var delegate: CountryFetcherDelegate?

    func fetchCountries() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let success = Bool.random()
            if success {
                self.delegate?.onLoadSuccessfully(countries: countries)
            } else {
                self.delegate?.onLoadError(error: CountryFetcherError())
            }
        }
    }
}
