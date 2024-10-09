//
//  ThumbnailFetcher.swift
//  iOSExperimentHub
//
//  Created by HuyPT3 on 04/10/2024.
//

import UIKit

protocol ThumbnailFetcherDelegate {
    func onLoadSuccessfully()
    func onStartLoad()
}

class ThumbnailFetcher {
    private let thumbSize = CGSize(width: 40, height: 40)
    var delegate: ThumbnailFetcherDelegate?
    
    func fetchThumbnails(
        for urls: [String],
        completion handler: @escaping ([String: UIImage]?, Error?) -> Void
    ) {
        guard let url = urls.first,
              let request = thumbnailURLRequest(from: url)
        else { return handler([:], nil) }
       
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response,
                  let data = data
            else {
                return handler(nil, error)
            }
                
            UIImage(data: data)?.prepareThumbnail(of: self.thumbSize) { image in
                guard let image = image else {
                    return handler(nil, ThumbnailFailedError())
                }
                    
                self.fetchThumbnails(for: Array(urls.dropFirst())) { thumbnails, error in
                    var updatedThumbnails = thumbnails ?? [:]
                    updatedThumbnails[url] = image
                    handler(updatedThumbnails, error)
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchThumbnails(for urls: [String]) async throws -> [String: UIImage] {
        var thumbnails: [String: UIImage] = [:]
        for url in urls {
            let request = thumbnailURLRequest(from: url)
            guard let request else { throw ThumbnailFailedError() }
            let (data, response) = try await URLSession.shared.data(for: request)
            try valurlateResponse(response)
            guard let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: thumbSize) else {
                throw ThumbnailFailedError()
            }
            thumbnails[url] = image
        }
        return thumbnails
    }
    
    func fetchThumbnailsGroup(for urls: [String]) async throws -> [String: UIImage] {
        var thumbnails: [String: UIImage] = [:]
        try await withThrowingTaskGroup(of: (String, UIImage).self) { group in
            for url in urls {
                group.addTaskUnlessCancelled {
                    return (url, try await self.fetchOneThumbnail(withurl: url))
                }
            }
            
           for try await (url, thumbnail) in group {
               thumbnails[url] = thumbnail
           }
        }
        return thumbnails
    }
    
    func fetchOneThumbnail(withurl url: String) async throws -> UIImage {
        let imageReq = imageRequest(for: url)
        let metadataReq = metadataRequest(for: url)
        
        async let (data, _) = URLSession.shared.data(for: imageReq)
        async let (metadata, _) = URLSession.shared.data(for: metadataReq)
                
        guard let size = try parseSize(from: await metadata),
              let image = try await UIImage(data: data)?.byPreparingThumbnail(ofSize: size)
        else {
            throw ThumbnailFailedError()
        }
        return image
    }
    
    func thumbnailURLRequest(from urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            print("Invalurl URL string.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    private func imageRequest(for url: String) -> URLRequest {
        return URLRequest(url: URL(string: "https://example.com/\(url)/image")!)
    }
    
    private func metadataRequest(for url: String) -> URLRequest {
        return URLRequest(url: URL(string: "https://example.com/\(url)/metadata")!)
    }
    
    private func valurlateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ThumbnailFailedError()
        }
    }
    
    private func parseSize(from metadata: Data) -> CGSize? {
        return CGSize(width: 40, height: 40)
    }
}

struct ThumbnailFailedError: Error {}
