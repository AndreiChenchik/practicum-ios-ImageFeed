//
//  ModelLoading.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 20/1/23.
//

import Foundation

protocol ModelLoading {
    @discardableResult func fetch<Model: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask
}

extension ModelLoading {
    @discardableResult
    func fetch<Model: Decodable>(
        url: URL,
        bearerToken: String? = nil,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        var request = URLRequest(url: url)
        if let bearerToken {
            request.setValue(
                "Bearer \(bearerToken)",
                forHTTPHeaderField: "Authorization"
            )
        }

        return fetch(request: request, handler: handler)
    }
}
