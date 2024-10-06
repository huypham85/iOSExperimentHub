//
//  CountryListTableViewCell.swift
//  iOSExperimentHub
//
//  Created by Huy Pham on 28/9/24.
//

import UIKit

enum FetchError: Error {
    case badID
    case badImage
}

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ country: Country) async {
        countryLabel.text = country.name
//        fetchThumbnail(for: country.thumbnailURL) { [weak self] image, _ in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                self?.thumbnailImageView.image = image
//                self?.activityIndicator.stopAnimating()
//            }
//        }
        
//        Task {
            do {
                thumbnailImageView.image = try await fetchThumbnail(for: country.thumbnailURL)
                activityIndicator.stopAnimating()
            } catch {
                print("Error while fetching image")
            }
//        }
    }
    
    func thumbnailURLRequest(from urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchThumbnail(for url: String) async throws -> UIImage {
        activityIndicator.startAnimating()
        
        let request = thumbnailURLRequest(from: url)!
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    // ⚠️ oh no forget to call resume
                    continuation.resume(returning: UIImage(data: data!)!)
                }
            }
            task.resume()
        }
    }
    
    func fetchThumbnail(for url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        activityIndicator.startAnimating()
        let request = thumbnailURLRequest(from: url)!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(FetchError.badID))
            } else {
                guard let image = UIImage(data: data!) else {
                    completion(.failure(FetchError.badImage))
                    return
                }
                image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in
                    guard let thumbnail = thumbnail else {
                        completion(.failure(FetchError.badImage))
                        return
                    }
                    completion(.success(thumbnail))
                }
            }
        }
        task.resume()
    }
    
    
//    func fetchThumbnail(for url: String) async throws -> UIImage {
//        activityIndicator.startAnimating()
//        let request = thumbnailURLRequest(from: url)!
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
//        let maybeImage = UIImage(data: data)
//        guard let thumbnail = await maybeImage?.thumbnail else { throw FetchError.badImage }
//        return thumbnail
//    }
}
