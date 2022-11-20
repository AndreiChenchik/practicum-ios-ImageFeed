import Foundation

protocol ModelLoading {
    @discardableResult func fetch<Model: Decodable>(
        url: URL,
        bearerToken: String?,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask

    @discardableResult func fetch<Model: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask
}

extension ModelLoading {
    @discardableResult func fetch<Model: Decodable>(
        url: URL,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        fetch(url: url, bearerToken: nil, handler: handler)
    }
}

struct ModelService: ModelLoading {
    private let networkClient: NetworkRouting

    init(
        networkClient: NetworkRouting
    ) {
        self.networkClient = networkClient
    }

    func fetch<Model: Decodable>(
        url: URL,
        bearerToken: String?,
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

    func fetch<Model: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        return networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Model.self, from: data)

                    handler(.success(model))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
